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
    const topLayers    = ['tithi', 'nakshatra'];
    const bottomLayers = ['yoga', 'karana'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // ── Row 1: tithi + nakshatra ──
          Row(
            children: topLayers.map((ly) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: ly == 'tithi' ? 6 : 0,
                  ),
                  child: _LayerCard(
                    layer: ly,
                    name: _nameFor(ly) ?? '',
                    isActive: activeLayer == ly,
                    onTap: () => onLayerChanged(ly),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // ── Row 2: yoga + karana ──
          Row(
            children: bottomLayers.map((ly) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: ly == 'yoga' ? 6 : 0,
                  ),
                  child: _LayerCard(
                    layer: ly,
                    name: _nameFor(ly) ?? '',
                    isActive: activeLayer == ly,
                    onTap: () => onLayerChanged(ly),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // ── Row 3: sankalpa full width ──
          // _LayerCard(
          //   layer: 'sankalpa',
          //   name: '',
          //   isActive: activeLayer == 'sankalpa',
          //   onTap: () => onLayerChanged('sankalpa'),
          //   fullWidth: true,
          // ),
        ],
      ),
    );
  }
}

class _LayerCard extends StatelessWidget {
  final String layer;
  final String name;
  final bool isActive;
  final VoidCallback onTap;
  final bool fullWidth;

  const _LayerCard({
    required this.layer,
    required this.name,
    required this.isActive,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = kLayerConfig[layer]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        
        duration: const Duration(milliseconds: 200),
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? cfg.highlight.withValues(alpha: 0.08)
              : kBg1.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? cfg.highlight.withValues(alpha: 0.45)
                : kSlate.withValues(alpha: 0.12),
            width: isActive ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── top row: icon + label tag ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  cfg.icon,
                  color: isActive
                      ? cfg.highlight
                      : kSlate.withValues(alpha: 0.5),
                  size: 18,
                ),
                Text(
                  cfg.label,
                  style: TextStyle(
                    color: isActive
                        ? cfg.highlight
                        : kSlate.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            if (layer != 'sankalpa') ...[
              const SizedBox(height: 8),

              // ── main name ──
              Text(
                name,
                style: TextStyle(
                  color: isActive ? Colors.white : kSlate.withValues(alpha: 0.85),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),


              // ── sub detail ──
              Text(
                cfg.detail ?? '',
                style: TextStyle(
                  color: isActive
                      ? cfg.highlight.withValues(alpha: 0.75)
                      : kSlate.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 10),

              // ── accent bar ──
              Container(
                height: 3,
                width: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? cfg.highlight
                      : kSlate.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ] else ...[
              const SizedBox(height: 6),
              Text(
                'संकल्प',
                style: TextStyle(
                  color: isActive ? Colors.white : kSlate.withValues(alpha: 0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
// in home_models.dart — add to LayerConfig
class LayerConfig {
  final Color highlight;
  final String label;
  final IconData icon;       // ← add
  final String? detail;      // ← add (e.g. "Ends at 08:14 PM")
  
  const LayerConfig({
    required this.highlight,
    required this.label,
    required this.icon,
    this.detail,
  });
}

// example entries
const kLayerConfig = {
  'tithi':     LayerConfig(highlight: kGold,              label: 'तिथी',    icon: Icons.nightlight_round,  detail: 'Ends at 08:14 PM'),
  'nakshatra': LayerConfig(highlight: Color(0xFFe879a0),  label: 'नक्षत्र', icon: Icons.auto_awesome,      detail: '11h 05m remaining'),
  'yoga':      LayerConfig(highlight: Color(0xFF38bdf8),  label: 'योग',     icon: Icons.grain,             detail: 'Next: Vishkumbha'),
  'karana':    LayerConfig(highlight: Color(0xFFa78bfa),  label: 'करण',     icon: Icons.straighten,        detail: 'Active until 09:22 AM'),
  'sankalpa':  LayerConfig(highlight: Color(0xFF4ade80),  label: 'संकल्प',  icon: Icons.auto_fix_high),
};