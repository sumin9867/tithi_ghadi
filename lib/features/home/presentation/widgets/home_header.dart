import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/home_models.dart';

class HomeHeader extends StatelessWidget {
  final String locName;
  final String bsDateStr;
  final VoidCallback onLocationTap;
  final VoidCallback onDateTap;

  const HomeHeader({
    super.key,
    required this.locName,
    required this.bsDateStr,
    required this.onLocationTap,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kGold.withOpacity(0.2), width: 0.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onLocationTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined, color: kGold, size: 14),
                const SizedBox(width: 4),
                Text(
                  locName.substring(0, math.min(locName.length, 12)),
                  style: const TextStyle(color: kGold, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            'तिथी घडी',
            style: TextStyle(
                color: kText, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onDateTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_outlined, color: kCyan, size: 14),
                const SizedBox(width: 4),
                Text(
                  bsDateStr,
                  style: const TextStyle(color: kCyan, fontSize: 11, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
