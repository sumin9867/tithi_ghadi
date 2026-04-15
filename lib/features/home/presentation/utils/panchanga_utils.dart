import 'dart:math' as math;
import '../models/home_models.dart';

// ══════════════════════════════════════════════════════════════════════════
// ASTRONOMY & VEDIC TIME CALCULATIONS
// ══════════════════════════════════════════════════════════════════════════

double mod360(double a) => ((a % 360) + 360) % 360;

double jdn(DateTime d) => d.millisecondsSinceEpoch / 86400000.0 + 2440587.5;

double sunLon(double jd) {
  final n = jd - 2451545;
  final L = mod360(280.46 + 0.985647 * n);
  final g = mod360(357.528 + 0.9856 * n) * math.pi / 180;
  return mod360(L + 1.915 * math.sin(g) + 0.02 * math.sin(2 * g));
}

double moonLon(double jd) {
  final T = (jd - 2451545) / 36525;
  final L = mod360(218.3164477 + 481267.88123421 * T);
  final M = mod360(134.9633964 + 477198.8675055 * T) * math.pi / 180;
  final D = mod360(297.8501921 + 445267.1114034 * T) * math.pi / 180;
  return mod360(
    L +
        6.2888 * math.sin(M) -
        1.274 * math.sin(2 * D - M) +
        0.6583 * math.sin(2 * D) -
        0.2136 * math.sin(2 * M),
  );
}

/// Calculate vedic (local solar) time in 0–24 decimal hours for a given location
double vedicDecimal(DateTime date, double lonDeg) {
  final utcH = date.toUtc().hour +
      date.toUtc().minute / 60.0 +
      date.toUtc().second / 3600.0;
  final jd = jdn(date);
  final n = jd - 2451545;
  final lRad = mod360(280.46 + 0.985647 * n) * math.pi / 180;
  final gRad = mod360(357.528 + 0.9856 * n) * math.pi / 180;
  final eot =
      (-1.915 * math.sin(gRad) -
          0.02 * math.sin(2 * gRad) +
          2.466 * math.sin(2 * lRad) -
          0.053 * math.sin(4 * lRad)) /
      60;
  return ((utcH + lonDeg / 15 + eot) % 24 + 24) % 24;
}

/// Get VedicTime object (hour, minute, second, decimal) for a given location
VedicTime getVedicTime(DateTime date, double lon) {
  final dec = vedicDecimal(date, lon);
  final h = dec.floor();
  final mf = (dec - h) * 60;
  final m = mf.floor();
  final s = ((mf - m) * 60).floor();
  return VedicTime(h, m, s, dec);
}

/// Calculate sunrise (isRise=true) or sunset (isRise=false) time in 0–24 decimal hours
double? calcRiseSet(
  DateTime date,
  double lat,
  double lon,
  double tzH,
  bool isRise,
) {
  final jd = jdn(date);
  final n = jd - 2451545;
  final L = mod360(280.46 + 0.985647 * n);
  final g = mod360(357.528 + 0.9856 * n) * math.pi / 180;
  final lam =
      (L + 1.915 * math.sin(g) + 0.02 * math.sin(2 * g)) * math.pi / 180;
  final eps = 23.439 * math.pi / 180;
  final dec = math.asin(math.sin(eps) * math.sin(lam));
  final cosH =
      (math.sin(-0.833 * math.pi / 180) -
          math.sin(lat * math.pi / 180) * math.sin(dec)) /
      (math.cos(lat * math.pi / 180) * math.cos(dec));
  if (cosH.abs() > 1) return null;
  final H = math.acos(cosH) * 180 / math.pi;
  final eqTime = -(L - (lam / (math.pi / 180))) / 15;
  final transit = 12 + eqTime - (lon / 15 - tzH);
  return ((isRise ? transit - H / 15 : transit + H / 15) % 24 + 24) % 24;
}

// ══════════════════════════════════════════════════════════════════════════
// DATE CONVERSION & TIME HELPERS
// ══════════════════════════════════════════════════════════════════════════

/// Parse ISO datetime string to 0–24 decimal hour in Nepal time (+5:45)
double isoToDecimalHour(String? iso, {double fallback = 0.0}) {
  if (iso == null || iso.isEmpty) return fallback;
  try {
    final dt = DateTime.parse(iso).add(const Duration(hours: 11, minutes: 30));
    return dt.hour + dt.minute / 60.0 + dt.second / 3600.0;
  } catch (_) {
    return fallback;
  }
}

/// Nepali month names (1-based: 1=Baishakh, 12=Chaitra)
const _nepaliMonthNames = [
  'बैशाख',
  'जेठ',
  'आषाढ',
  'श्रावण',
  'भाद्र',
  'आश्विन',
  'कार्तिक',
  'मार्गशीर्ष',
  'पौष',
  'माघ',
  'फाल्गुन',
  'चैत्र',
];

/// Get Nepali month name from month number (1–12)
String nepaliMonthName(int month) => _nepaliMonthNames[(month - 1) % 12];

/// Convert AD date to Nepali (BS) date
/// Uses offset: BS = AD + 56 years and ~8.5 months
({int year, int month, int day}) adToNepaliDate(DateTime adDate) {
  // Standard offset: Nepali calendar is ~56.7 years ahead
  // This is an approximation; precise conversion requires lookup tables
  int bsYear = adDate.year + 56;
  int bsMonth = adDate.month + 8;
  int bsDay = adDate.day + 15; // Approximate

  // Adjust for month overflow
  if (bsMonth > 12) {
    bsYear += (bsMonth - 1) ~/ 12;
    bsMonth = ((bsMonth - 1) % 12) + 1;
  }

  // Adjust for day overflow (approximate)
  if (bsDay > 32) {
    bsMonth++;
    bsDay -= 32;
    if (bsMonth > 12) {
      bsYear++;
      bsMonth = 1;
    }
  }

  return (year: bsYear, month: bsMonth, day: bsDay);
}

/// Get Nepali year and month name from AD date
({int year, String month}) nepaliDateInfo(DateTime adDate) {
  final nd = adToNepaliDate(adDate);
  return (year: nd.year, month: nepaliMonthName(nd.month));
}

// ══════════════════════════════════════════════════════════════════════════
// NUMBER FORMATTING
// ══════════════════════════════════════════════════════════════════════════

/// Convert integer to Devanagari numerals
String toDevanagariNum(int n) {
  const digits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  return n.toString().split('').map((c) {
    final i = int.tryParse(c);
    return i != null ? digits[i] : c;
  }).join();
}
