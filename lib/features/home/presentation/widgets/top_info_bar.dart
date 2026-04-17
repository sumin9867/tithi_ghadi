import 'package:flutter/material.dart';
import '../models/home_models.dart';

class TopInfoBar extends StatelessWidget {
  final String varaStr;
  final String nsStr;
  final String vedicClockStr;

  const TopInfoBar({
    super.key,
    required this.varaStr,
    required this.nsStr,
    required this.vedicClockStr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kBg1.withValues(alpha: 0.6),
        border: Border(
          bottom: BorderSide(
            color: kGold.withValues(alpha: 0.12),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(varaStr, style: const TextStyle(color: kSlate, fontSize: 12)),
          Text(
            vedicClockStr,
            style: const TextStyle(
              color: kCyan,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
