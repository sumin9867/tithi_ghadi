import 'package:flutter/material.dart';
import 'package:tithi_gadhi/features/home/domain/panchang_daily_model.dart';
import '../models/home_models.dart';

class LayerTabBar extends StatelessWidget {
  final String activeLayer;
  final PanchangDailyModel day;
  final ValueChanged<String> onLayerChanged;

  const LayerTabBar({
    super.key,
    required this.activeLayer,
    required this.day,
    required this.onLayerChanged,
  });

  String? _nameFor(String layer) {
    switch (layer) {
      case 'nakshatra': return day.nakshatra.nameNp;
      case 'yoga':      return day.yoga.nameNp;
      case 'karana':    return day.karana.nameNp;
      default:          return day.tithi.nameNp;
    }
  }

  @override
  Widget build(BuildContext context) {
    const layers = ['tithi', 'nakshatra', 'yoga', 'karana', 'sankalpa'];
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: kBg1.withValues(alpha: 0.85),
        border: Border(top: BorderSide(color: kGold.withValues(alpha: 0.15), width: 0.5)),
      ),
      child: Row(
        children: layers.map((ly) {
          final cfg = kLayerConfigs[ly]!;
          final isOn = activeLayer == ly;
          return Expanded(
            child: GestureDetector(
              onTap: () => onLayerChanged(ly),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isOn ? cfg.highlight : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cfg.label,
                      style: TextStyle(
                        color: isOn ? cfg.highlight : kSlate.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: isOn ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (ly != 'sankalpa')
                      Text(
                        _nameFor(ly)??"",
                        style: TextStyle(
                          color: isOn
                              ? cfg.highlight.withValues(alpha: 0.8)
                              : kSlate.withValues(alpha: 0.4),
                          fontSize: 8,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
