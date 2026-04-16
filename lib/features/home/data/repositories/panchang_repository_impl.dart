import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/panchang_repository.dart';
import '../datasources/panchang_remote_data_source.dart';
import '../datasources/panchang_local_data_source.dart';
import '../../domain/panchang_daily_model.dart';

class PanchangRepositoryImpl implements PanchangRepository {
  final PanchangRemoteDataSource remoteDataSource;
  final PanchangLocalDataSource localDataSource;

  PanchangRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, MonthEventsResponse>> getDailyPanchang(
    DateTime date,
    String location,
  ) async {
    // 1. Check for a valid (non-expired) cached entry
    final cached = await localDataSource.getCachedPanchang(date, location);
    if (cached != null) {
      log('PanchangRepository: cache HIT for $date / $location');
      return Right(cached);
    }

    // 2. Cache miss or expired — try network
    try {
      final response = await remoteDataSource.fetchDailyPanchang(date, location);

      // 3. Persist to cache before returning
      await localDataSource.cachePanchang(date, location, response);
      log('PanchangRepository: fetched from network, cached for $date / $location');

      return Right(response);
    } on DioException catch (e) {
      log('PanchangRepository: DioException — ${e.message}');

      // 4. Network failed — try stale cache as offline fallback
      final stale = await localDataSource.getStalePanchang(date, location);
      if (stale != null) {
        log('PanchangRepository: returning stale cache for $date / $location');
        return Right(stale);
      }

      return Left(_mapDioException(e));
    } catch (e) {
      log('PanchangRepository: unexpected error — $e');

      // 5. Unexpected error — try stale cache before giving up
      final stale = await localDataSource.getStalePanchang(date, location);
      if (stale != null) {
        log('PanchangRepository: returning stale cache after unexpected error');
        return Right(stale);
      }

      return const Left(Failure.networkFailure('Failed to load daily panchang.'));
    }
  }

  Failure _mapDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      return const Failure.unauthorizedFailure('Unauthorized request.');
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const Failure.networkFailure('Connection timed out.');
    }
    return Failure.serverFailure(e.message);
  }
}
