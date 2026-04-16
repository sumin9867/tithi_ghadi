import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:tithi_gadhi/features/home/domain/panchang_daily_model.dart';
import '../models/home_models.dart';
import '../utils/panchanga_utils.dart';

class CenterOverlay extends StatefulWidget {
  final double size;
  final PanchangDetail detail; // active layer's panchang detail from API
  final LayerConfig layerConfig;
  final VedicTime vedicTime;
  final String bsDateStr;
  final bool isLive;

  const CenterOverlay({
    super.key,
    required this.size,
    required this.detail,
    required this.layerConfig,
    required this.vedicTime,
    required this.bsDateStr,
    required this.isLive,
  });

  @override
  State<CenterOverlay> createState() => _CenterOverlayState();
}

class _CenterOverlayState extends State<CenterOverlay> {
  late Timer _timer;
  String _countdown = '00:00:00';

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    final endIso = widget.detail.end;
    if (endIso == null || endIso.isEmpty) return;

    // Parse the BS ISO string directly as NepaliDateTime
    final endDt = NepaliDateTime.parse(
      endIso,
    ).add(const Duration(hours: 5, minutes: 45));
    final nowNepali = NepaliDateTime.now();

    final diffSeconds = endDt.difference(nowNepali).inSeconds;

    if (diffSeconds <= 0) {
      if (mounted) setState(() => _countdown = '00:00:00');
      return;
    }

    final h = diffSeconds ~/ 3600;
    final m = (diffSeconds % 3600) ~/ 60;
    final s = diffSeconds % 60;

    if (mounted) {
      setState(() {
        _countdown =
            '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  void didUpdateWidget(CenterOverlay old) {
    super.didUpdateWidget(old);
    if (old.detail != widget.detail) _updateCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmtIso(String? iso) {
    if (iso == null || iso.isEmpty) return '--:--';
    try {
      final dt = DateTime.parse(
        iso,
      ).add(const Duration(hours: 11, minutes: 30));
      final hh24 = dt.hour;
      final hh12 = hh24 % 12 == 0 ? 12 : hh24 % 12;
      final amPm = hh24 < 12 ? 'AM' : 'PM';
      final mm = dt.minute.toString().padLeft(2, '0');
      return '${hh12.toString().padLeft(2, '0')}:$mm $amPm';
    } catch (_) {
      return '--:--';
    }
  }

  String _startLabel(String? iso) {
    if (isIsoDateYesterday(iso)) return 'हिजो';
    if (isIsoDateTomorrow(iso)) return 'भोलि';
    return '';
  }

  String _endLabel(String? iso) {
    if (isIsoDateTomorrow(iso)) return 'भोलि';
    if (isIsoDateYesterday(iso)) return 'हिजो';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // Replace the startDisplay / endDisplay / timeRangeStr block with:
    final startTime = _fmtIso(widget.detail.start);
    final endTime = _fmtIso(widget.detail.end);
    final startLabel = _startLabel(widget.detail.start);
    final endLabel = _endLabel(widget.detail.end);

    final startDisplay = startLabel.isNotEmpty
        ? '$startTime ($startLabel)'
        : startTime;
    final endDisplay = endLabel.isNotEmpty ? '$endTime ($endLabel)' : endTime;

    final timeRangeStr = '$startDisplay – $endDisplay';

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment(-0.2, -0.3),
          colors: [Color(0xFF0d1e38), Color(0xFF03071e), Color(0xFF020810)],
          stops: [0.0, 0.52, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Layer label (तिथि / नक्षत्र etc.) ──
          Text(
            widget.layerConfig.label,
            style: TextStyle(
              color: kGold.withValues(alpha: 0.85),
              fontSize: math.max(widget.size * 0.045, 10),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),

          // ── Nepali name (large) ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size * 0.06),
            child: Text(
              widget.detail.nameNp ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kText,
                fontSize: math.min(widget.size * 0.13, 26),
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),

          // ── English name (small) ──
          if (widget.detail.nameEn?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.size * 0.06),
              child: Text(
                widget.detail.nameEn!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSlate.withValues(alpha: 0.75),
                  fontSize: math.max(widget.size * 0.038, 9),
                  letterSpacing: 0.3,
                ),
              ),
            ),

          const SizedBox(height: 5),

          // ── Time range ──
          Text(
            timeRangeStr,
            style: TextStyle(
              color: Colors.white,
              fontSize: math.max(widget.size * 0.040, 9),
              fontFamily: 'monospace',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),

          _divider(widget.size),
          const SizedBox(height: 6),

          // ── "बाँकी" label ──
          Text(
            'बाँकी',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: math.max(widget.size * 0.038, 8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),

          // ── Countdown timer ──
          Text(
            _countdown,
            style: TextStyle(
              color: const Color(0xFF00E5FF),
              fontSize: math.min(widget.size * 0.17, 38),
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 5),

          _divider(widget.size),
          const SizedBox(height: 5),

          // ── Vedic clock ──
          Text(
            widget.vedicTime.formatted,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: math.max(widget.size * 0.052, 13),
              fontFamily: 'monospace',
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),

          // ── BS / AD date ──
          Text(
            'आज: ${widget.bsDateStr}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.40),
              fontSize: math.max(widget.size * 0.036, 8),
              fontFamily: 'monospace',
            ),
          ),

          if (!widget.isLive)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade900.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.yellow.shade600.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  '📅 चुनिएको मिति',
                  style: TextStyle(color: Colors.yellow.shade400, fontSize: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _divider(double size) => Center(
    child: Container(
      width: size * 0.28,
      height: 0.6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            kGold.withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
    ),
  );
}
