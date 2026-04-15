import 'package:flutter/material.dart';

// ══ COLORS ══

const kBg0 = Color(0xFF03071e);
const kBg1 = Color(0xFF0d1e38);
const kCyan = Color(0xFF7ecef4);
const kGold = Color(0xFFc9963a);
const kGoldLt = Color(0xFFf0c060);
const kRed = Color(0xFFef4444);
const kText = Color(0xFFf0e8d8);
const kSlate = Color(0xFF8ba3bf);

// ══ LAYER CONFIGS ══

const kLayerConfigs = {
  'tithi': LayerConfig(
    colors: [
      Color(0xFF7c3aed),
      Color(0xFF9b5de5),
      Color(0xFFc084fc),
      Color(0xFFa855f7),
      Color(0xFFe879f9),
    ],
    highlight: Color(0xFFc084fc),
    rim: Color(0xFF9b5de5),
    label: 'तिथि',
    tabId: 'tithi',
  ),
  'nakshatra': LayerConfig(
    colors: [
      Color(0xFF9d174d),
      Color(0xFFbe123c),
      Color(0xFFe11d48),
      Color(0xFFf472b6),
      Color(0xFFfb7185),
    ],
    highlight: Color(0xFFf472b6),
    rim: Color(0xFFe91e8c),
    label: 'नक्षत्र',
    tabId: 'nakshatra',
  ),
  'yoga': LayerConfig(
    colors: [
      Color(0xFF0e7490),
      Color(0xFF0891b2),
      Color(0xFF06b6d4),
      Color(0xFF34d399),
      Color(0xFF2dd4bf),
    ],
    highlight: Color(0xFF34d399),
    rim: Color(0xFF00c9c8),
    label: 'योग',
    tabId: 'yoga',
  ),
  'karana': LayerConfig(
    colors: [
      Color(0xFF15803d),
      Color(0xFF16a34a),
      Color(0xFF22c55e),
      Color(0xFF86efac),
      Color(0xFF4ade80),
    ],
    highlight: Color(0xFF86efac),
    rim: Color(0xFF44cf6c),
    label: 'करण',
    tabId: 'karana',
  ),
  'sankalpa': LayerConfig(
    colors: [Color(0xFF7c3aed)],
    highlight: Color(0xFFc084fc),
    rim: Color(0xFF9b5de5),
    label: 'संकल्प',
    tabId: 'sankalpa',
  ),
};

// ══ BS MONTH NAMES (Nepal Sambat / BS calendar display) ══

const kMonthsNS = [
  'वैशाख',
  'ज्येष्ठ',
  'आषाढ',
  'श्रावण',
  'भाद्रपद',
  'आश्विन',
  'कार्तिक',
  'मार्गशीर्ष',
  'पौष',
  'माघ',
  'फाल्गुन',
  'चैत्र',
];

// ══ UI MODELS ══

class LayerConfig {
  final List<Color> colors;
  final Color highlight;
  final Color rim;
  final String label;
  final String tabId;
  const LayerConfig({
    required this.colors,
    required this.highlight,
    required this.rim,
    required this.label,
    required this.tabId,
  });
}

class VedicTime {
  final int h, m, s;
  final double decimal;
  const VedicTime(this.h, this.m, this.s, this.decimal);
  String get formatted {
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    final amPm = h < 12 ? 'AM' : 'PM';
    return '${hour12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')} $amPm';
  }
}

class Star {
  double x, y, r, alpha, dAlpha;
  Star({
    required this.x,
    required this.y,
    required this.r,
    required this.alpha,
    required this.dAlpha,
  });
}
