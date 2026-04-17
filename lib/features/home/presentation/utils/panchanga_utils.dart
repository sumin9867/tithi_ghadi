import 'dart:math' as math;
import 'package:nepali_utils/nepali_utils.dart';
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
  final utcH =
      date.toUtc().hour +
      date.toUtc().minute / 60.0 +
      date.toUtc().second / 3600.0 +
      date.toUtc().millisecond / 3600000.0;
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
  const eps = 23.439 * math.pi / 180;
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
double isoToDecimalHour(String? iso, String type, {double fallback = 0.0}) {
  if (iso == null || iso.isEmpty) {
    return fallback;
  }

  try {
    final dtParsed = DateTime.parse(iso);
    final dt = dtParsed.add(
      const Duration(hours: 11, minutes: 30),
    ); // +05:45 Nepal
    final today = NepaliDateTime.now();

    // Check if the date is before today
    final isYesterday =
        dt.year == today.year && dt.month == today.month && dt.day < today.day;

    if (isYesterday) {
      return 0.0; // arc starts from midnight
    }

    return dt.hour + dt.minute / 60.0 + dt.second / 3600.0;
  } catch (e) {
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
({int year, int month, int day}) adToNepaliDate(DateTime adDate) {
  final bs = adDate.toNepaliDateTime();
  return (year: bs.year, month: bs.month, day: bs.day);
}

/// Get Nepali year and month name from AD date
({int year, String month}) nepaliDateInfo(DateTime adDate) {
  final nd = adToNepaliDate(adDate);
  return (year: nd.year, month: nepaliMonthName(nd.month));
}

// ══════════════════════════════════════════════════════════════════════════
// DATE CHECKS (for determining yesterday/tomorrow labels)
// ══════════════════════════════════════════════════════════════════════════

/// Returns true if the ISO datetime's calendar date is yesterday (Nepal time)
bool isIsoDateYesterday(String? iso) {
  if (iso == null || iso.isEmpty) return false;
  try {
    final dt = NepaliDateTime.parse(iso);
    final today = NepaliDateTime.now();
    final yesterday = NepaliDateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 1));
    final dtDate = NepaliDateTime(dt.year, dt.month, dt.day);
    return dtDate == yesterday;
  } catch (_) {
    return false;
  }
}

bool isIsoDateTomorrow(String? iso) {
  if (iso == null || iso.isEmpty) return false;
  try {
    final dt = NepaliDateTime.parse(iso);
    final today = NepaliDateTime.now();
    final tomorrow = NepaliDateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: 1));
    final dtDate = NepaliDateTime(dt.year, dt.month, dt.day);
    return dtDate == tomorrow;
  } catch (_) {
    return false;
  }
}

bool isIsoDateYesterdayLabel(String? iso) {
  if (iso == null || iso.isEmpty) return false;
  try {
    final isoDatePart = iso.substring(0, 10);
    final today = NepaliDateTime.now();
    final yesterday = NepaliDateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 1));
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    return isoDatePart == yesterdayStr;
  } catch (_) {
    return false;
  }
}

bool isIsoDateTomorrowLabel(String? iso) {
  if (iso == null || iso.isEmpty) return false;
  try {
    final isoDatePart = iso.substring(0, 10);
    final today = NepaliDateTime.now();
    final tomorrow = NepaliDateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: 1));
    final tomorrowStr =
        '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
    return isoDatePart == tomorrowStr;
  } catch (_) {
    return false;
  }
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
