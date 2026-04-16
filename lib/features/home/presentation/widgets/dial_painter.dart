import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tithi_gadhi/features/home/domain/panchang_daily_model.dart';
import '../models/home_models.dart';
import '../utils/panchanga_utils.dart';

class DialPainter extends CustomPainter {
final PanchangDetail tithiDetail;
final PanchangDetail nakshatraDetail;
final PanchangDetail activeDetail;
final LayerConfig cfg;
final double nowH;
final double riseH;
final double setH;
final VedicTime vedicTime;
final bool isLive;
final double animValue;

DialPainter({
required this.tithiDetail,
required this.nakshatraDetail,
required this.activeDetail,
required this.cfg,
required this.nowH,
required this.riseH,
required this.setH,
required this.vedicTime,
required this.isLive,
required this.animValue,
});

double _hToAngle(double h) => (h / 24) * 2 * math.pi - math.pi / 2;

Offset _polarToCart(Offset center, double r, double angle) =>
Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));

@override
void paint(Canvas canvas, Size size) {
final cx = size.width / 2;
final cy = size.height / 2;
final center = Offset(cx, cy);
final R = size.width * 0.455;

// ── Dark background circle ──
canvas.drawCircle(center, R * 1.18, Paint()..color = const Color(0xFF050A1F));

// ── Face gradient ──
canvas.drawCircle(
center,
R * 1.18,
Paint()
..shader = const RadialGradient(
center: Alignment(-0.2, -0.3),
radius: 0.85,
colors: [Color(0xFF0d1e38), Color(0xFF03071e), Color(0xFF020810)],
stops: [0.0, 0.55, 1.0],
).createShader(Rect.fromCircle(center: center, radius: R * 1.18)),
);

// ══════════════════════════════════════════
// RING 1 — OUTER GOLD 24-HOUR SCALE RING
// ══════════════════════════════════════════
final outerRingR = R * 1.10;
final outerRingW = R * 0.055;

canvas.drawCircle(
center,
outerRingR,
Paint()
..color = const Color(0xFFC8973A).withValues(alpha: 0.18)
..style = PaintingStyle.stroke
..strokeWidth = outerRingW,
);
canvas.drawCircle(
center,
outerRingR + outerRingW * 0.5,
Paint()
..color = const Color(0xFFC8973A).withValues(alpha: 0.55)
..style = PaintingStyle.stroke
..strokeWidth = 1.2,
);
canvas.drawCircle(
center,
outerRingR - outerRingW * 0.5,
Paint()
..color = const Color(0xFFC8973A).withValues(alpha: 0.35)
..style = PaintingStyle.stroke
..strokeWidth = 0.8,
);

// ── Tick marks & hour labels ──
for (int i = 0; i < 24; i++) {
final a = _hToAngle(i.toDouble());
final isMaj = i % 6 == 0;
final isMid = i % 3 == 0;
final tickOuter = outerRingR + outerRingW * 0.45;
final tl = isMaj ? outerRingW * 1.1 : isMid ? outerRingW * 0.7 : outerRingW * 0.4;
final p1 = _polarToCart(center, tickOuter, a);
final p2 = _polarToCart(center, tickOuter - tl, a);
final isCard = i == 0 || i == 6 || i == 12 || i == 18;
canvas.drawLine(
p1, p2,
Paint()
..color = isCard ? kCyan.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.4)
..strokeWidth = isMaj ? 2.2 : isMid ? 1.4 : 0.9
..strokeCap = StrokeCap.round,
);

final labelR = outerRingR + outerRingW * 1.35;
final lp = _polarToCart(center, labelR, a);
final label = i < 10 ? '0$i' : '$i';
final tp = TextPainter(
text: TextSpan(
text: label,
style: TextStyle(
color: isCard ? Colors.white : kCyan.withValues(alpha: 0.8),
fontSize: isMaj ? math.max(size.width * 0.035, 12.0) : math.max(size.width * 0.028, 10.0),
fontWeight: isMaj ? FontWeight.bold : FontWeight.w500,
fontFamily: 'monospace',
),
),
textDirection: TextDirection.ltr,
)..layout();
canvas.save();
canvas.translate(lp.dx, lp.dy);
canvas.rotate(a + math.pi / 2);
tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
canvas.restore();
}

// Colored cardinal dots
final dotPositions = {
0: kCyan,
6: const Color(0xFFfb923c),
12: kCyan,
18: const Color(0xFFfb923c),
};
dotPositions.forEach((h, col) {
final a = _hToAngle(h.toDouble());
final dp = _polarToCart(center, outerRingR + outerRingW * 0.48, a);
canvas.drawCircle(dp, 3.5,
Paint()..color = col..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
canvas.drawCircle(dp, 2.5, Paint()..color = col);
});

// ══════════════════════════════════════════
// RING 2 — NAKSHATRA ARC
// ══════════════════════════════════════════
final nakshatraRingR = R * 0.92;
final nakshatraRingW = R * 0.058;

canvas.drawCircle(
center,
nakshatraRingR,
Paint()
..color = Colors.white.withValues(alpha: 0.04)
..style = PaintingStyle.stroke
..strokeWidth = nakshatraRingW,
);

var nStart = isoToDecimalHour(nakshatraDetail.start,nakshatraDetail.typeEn??"", fallback: 0.0);
var nEnd = isoToDecimalHour(nakshatraDetail.end,nakshatraDetail.typeEn??"", fallback: 24.0);
// If started yesterday, event was already active at midnight → draw from 00:00
if (isIsoDateYesterday(nakshatraDetail.start)) {
nStart = 0.0;
} else if (nEnd < nStart) {
// Clamp end to 24 if it wraps past midnight (nEnd < nStart indicates next day)
nEnd = 24.0;
}
// If end is tomorrow, extend to midnight
if (isIsoDateTomorrow(nakshatraDetail.end)) {
nEnd = 24.0;
}
_drawArcGlow(
canvas, center, nakshatraRingR,
_hToAngle(nStart), _hToAngle(nEnd),
const Color(0xFF6B9BAA), nakshatraRingW,
opacity: 0.85,
glowColor: const Color(0xFF4ECDC4),
glowRadius: 4.0,
);

for (final h in [nStart, nEnd]) {
final a = _hToAngle(h);
final pt = _polarToCart(center, nakshatraRingR, a);
canvas.drawCircle(pt, 4.0,
Paint()..color = const Color(0xFF4ECDC4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
canvas.drawCircle(pt, 2.5, Paint()..color = Colors.white);
}

// ══════════════════════════════════════════
// RING 3 — ACTIVE LAYER ARC (Tithi, Yoga, Karana, Sankalpa, etc.)
// ══════════════════════════════════════════
final activeRingR = R * 0.77;
final activeRingW = R * 0.095;

canvas.drawCircle(
center,
activeRingR,
Paint()
..color = Colors.white.withValues(alpha: 0.04)
..style = PaintingStyle.stroke
..strokeWidth = activeRingW,
);

var aStart = isoToDecimalHour(activeDetail.start,activeDetail.nameEn??"", fallback: 0.0);
var aEnd = isoToDecimalHour(activeDetail.end,activeDetail.nameEn??"", fallback: 24.0);
// If started yesterday, event was already active at midnight → draw from 00:00
if (isIsoDateYesterday(activeDetail.start)) {
aStart = 0.0;
} else if (aEnd < aStart) {
// Clamp end to 24 if it wraps past midnight (aEnd < aStart indicates next day)
aEnd = 24.0;
}
// If end is tomorrow, extend to midnight
if (isIsoDateTomorrow(activeDetail.end)) {
aEnd = 24.0;
}
_drawArcGlow(
canvas, center, activeRingR,
_hToAngle(aStart), _hToAngle(aEnd),
cfg.highlight, activeRingW,
opacity: 0.92,
glowColor: cfg.rim,
glowRadius: 8.0,
);

for (final h in [aStart, aEnd]) {
final a = _hToAngle(h);
final pt = _polarToCart(center, activeRingR, a);
canvas.drawCircle(pt, 5.0,
Paint()..color = cfg.highlight..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
canvas.drawCircle(pt, 3.0, Paint()..color = Colors.white.withValues(alpha: 0.9));
}


// ── Sun rise/set markers ──
for (final pair in [
[riseH, const Color(0xFFfde68a)],
[setH, const Color(0xFFfb923c)],
]) {
final h = pair[0] as double;
final col = pair[1] as Color;
final a = _hToAngle(h);
final r1 = _polarToCart(center, nakshatraRingR - nakshatraRingW * 0.7, a);
final r2 = _polarToCart(center, nakshatraRingR + nakshatraRingW * 0.7, a);
canvas.drawLine(r1, r2,
Paint()..color = col..strokeWidth = 2.5..strokeCap = StrokeCap.round);
}

// ══════════════════════════════════════════
// TIME NEEDLE
// ══════════════════════════════════════════
if (isLive) {
final ha = _hToAngle(nowH);
final tipPt = _polarToCart(center, nakshatraRingR + nakshatraRingW * 0.3, ha);
final heelPt = _polarToCart(center, -R * 0.08, ha);
canvas.drawLine(heelPt, tipPt,
Paint()
..color = kRed.withValues(alpha: 0.3)
..strokeWidth = size.width * 0.010
..strokeCap = StrokeCap.round
..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
canvas.drawLine(heelPt, tipPt,
Paint()
..color = kRed.withValues(alpha: 0.95)
..strokeWidth = size.width * 0.0038
..strokeCap = StrokeCap.round);
} else {
final ha = _hToAngle(nowH);
final tipPt = _polarToCart(center, R * 0.75, ha);
final heelPt = _polarToCart(center, -R * 0.07, ha);
canvas.drawLine(heelPt, tipPt,
Paint()
..color = kCyan.withValues(alpha: 0.85)
..strokeWidth = size.width * 0.004
..strokeCap = StrokeCap.round);
}

// ── Center jewel ──
canvas.drawCircle(center, size.width * 0.022, Paint()..color = kBg0);
canvas.drawCircle(center, size.width * 0.022,
Paint()
..color = kGold.withValues(alpha: 0.7)
..style = PaintingStyle.stroke
..strokeWidth = size.width * 0.007);
canvas.drawCircle(center, size.width * 0.007,
Paint()..color = isLive ? kRed : const Color(0xFFfcd34d));
}

void _drawArcGlow(
Canvas canvas,
Offset center,
double radius,
double startAngle,
double endAngle,
Color color,
double strokeWidth, {
double opacity = 1.0,
Color? glowColor,
double glowRadius = 6.0,
}) {
final span = ((endAngle - startAngle) % (2 * math.pi) + 2 * math.pi) % (2 * math.pi);
final rect = Rect.fromCircle(center: center, radius: radius);
if (glowColor != null) {
canvas.drawArc(
rect, startAngle, span, false,
Paint()
..color = glowColor.withValues(alpha: opacity * 0.35)
..style = PaintingStyle.stroke
..strokeWidth = strokeWidth * 1.6
..strokeCap = StrokeCap.round
..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius),
);
}
canvas.drawArc(
rect, startAngle, span, false,
Paint()
..color = color.withValues(alpha: opacity)
..style = PaintingStyle.stroke
..strokeWidth = strokeWidth
..strokeCap = StrokeCap.round,
);
}

@override
bool shouldRepaint(DialPainter old) =>
old.animValue != animValue ||
old.nowH != nowH ||
old.vedicTime.s != vedicTime.s ||
old.cfg != cfg ||
old.tithiDetail != tithiDetail ||
old.nakshatraDetail != nakshatraDetail ||
old.activeDetail != activeDetail;
}
