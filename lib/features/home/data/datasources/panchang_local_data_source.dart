import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';

import '../../domain/panchang_daily_model.dart';

// ── Constants ──────────────────────────────────────────────────────────────

const String kPanchangBoxName = 'panchang_cache';
const Duration kCacheTtl = Duration(days: 7);

// ── Abstract interface ─────────────────────────────────────────────────────

abstract class PanchangLocalDataSource {
  /// Returns cached [MonthEventsResponse] if a valid (non-expired) entry
  /// exists for the given [date] and [location]. Returns null on miss.
  Future<MonthEventsResponse?> getCachedPanchang(DateTime date, String location);

  /// Saves [response] to the cache under the key for [date] and [location].
  Future<void> cachePanchang(
    DateTime date,
    String location,
    MonthEventsResponse response,
  );

  /// Returns stale (expired) cached data for [date] and [location] if it
  /// exists, regardless of TTL. Used for offline fallback.
  Future<MonthEventsResponse?> getStalePanchang(DateTime date, String location);
}

// ── Hive implementation ────────────────────────────────────────────────────

class PanchangLocalDataSourceImpl implements PanchangLocalDataSource {
  final Box<String> _box;

  PanchangLocalDataSourceImpl(this._box);

  // Cache key format: panchang_YYYY-MM-DD_location
  String _cacheKey(DateTime date, String location) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return 'panchang_$y-$m-${d}_$location';
  }

  @override
  Future<MonthEventsResponse?> getCachedPanchang(
    DateTime date,
    String location,
  ) async {
    try {
      final key = _cacheKey(date, location);
      final raw = _box.get(key);
      if (raw == null) return null;

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(map['cachedAt'] as String);
      final age = DateTime.now().difference(cachedAt);

      if (age > kCacheTtl || age.isNegative) {
        // TTL expired or clock-skewed — caller should fetch fresh data
        return null;
      }

      return MonthEventsResponse.fromJson(
        map['response'] as Map<String, dynamic>,
      );
    } catch (e) {
      // Corrupt or unreadable entry — treat as miss
      log('PanchangLocalDataSource: cache read error: $e');
      return null;
    }
  }

  @override
  Future<void> cachePanchang(
    DateTime date,
    String location,
    MonthEventsResponse response,
  ) async {
    try {
      final key = _cacheKey(date, location);
      final entry = jsonEncode({
        'cachedAt': DateTime.now().toIso8601String(),
        'response': response.toJson(),
      });
      await _box.put(key, entry);

      // Evict old entries to prevent unbounded growth
      await _evictExpiredEntries();
    } catch (e) {
      // Cache write failure is non-fatal — log and continue
      log('PanchangLocalDataSource: cache write error: $e');
    }
  }

  @override
  Future<MonthEventsResponse?> getStalePanchang(
    DateTime date,
    String location,
  ) async {
    try {
      final key = _cacheKey(date, location);
      final raw = _box.get(key);
      if (raw == null) return null;

      final map = jsonDecode(raw) as Map<String, dynamic>;
      return MonthEventsResponse.fromJson(
        map['response'] as Map<String, dynamic>,
      );
    } catch (e) {
      log('PanchangLocalDataSource: stale cache read error: $e');
      return null;
    }
  }

  /// Deletes cache entries older than 14 days and compacts the box.
  Future<void> _evictExpiredEntries() async {
    try {
      final expiryCutoff = DateTime.now().subtract(kCacheTtl * 2); // 14 days
      final keysToDelete = <dynamic>[];

      for (final key in _box.keys) {
        try {
          final raw = _box.get(key as String);
          if (raw == null) continue;

          final map = jsonDecode(raw) as Map<String, dynamic>;
          final cachedAt = DateTime.parse(map['cachedAt'] as String);

          if (cachedAt.isBefore(expiryCutoff)) {
            keysToDelete.add(key);
          }
        } catch (_) {
          // Delete corrupt entries too
          keysToDelete.add(key);
        }
      }

      if (keysToDelete.isNotEmpty) {
        await _box.deleteAll(keysToDelete);
        await _box.compact();
        log('PanchangLocalDataSource: evicted ${keysToDelete.length} expired entries');
      }
    } catch (e) {
      log('PanchangLocalDataSource: eviction error (non-fatal): $e');
    }
  }
}
