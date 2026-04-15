import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:tithi_gadhi/core/network/dio_client.dart';
import 'package:tithi_gadhi/features/home/data/datasources/panchang_remote_data_source.dart';
import 'package:tithi_gadhi/features/home/data/repositories/panchang_repository_impl.dart';
import 'package:tithi_gadhi/features/home/domain/panchang_daily_model.dart';
import 'package:tithi_gadhi/features/home/presentation/cubit/tithi_ghadi_cubit.dart';

import '../models/home_models.dart';
import '../utils/panchanga_utils.dart';
import '../widgets/starfield_painter.dart';
import '../widgets/dial_painter.dart';
import '../widgets/home_header.dart';
import '../widgets/top_info_bar.dart';
import '../widgets/center_overlay.dart';
import '../widgets/layer_tab_bar.dart';
import '../widgets/location_modal.dart';
import '../widgets/date_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  double _lat = 27.7172, _lon = 85.3240, _tz = 5.75;
  String _locName = 'काठमाडौं';

  String _layer = 'tithi';
  DateTime? _selectedDate;
  late VedicTime _vt;
  late AnimationController _starCtrl;
  late AnimationController _handCtrl;
  final List<Star> _stars = [];

  late final TithiGhadiCubit _cubit;
  String _vedicClockStr = '';

  DateTime get _effectiveDate => _selectedDate ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    _vt = getVedicTime(DateTime.now(), _lon);
    _initStars();

    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    _handCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _handCtrl.addListener(_tick);
    _starCtrl.addListener(() => setState(() => _animateStars()));

    _cubit = TithiGhadiCubit(
      PanchangRepositoryImpl(
        PanchangRemoteDataSourceImpl(GetIt.I<DioClient>()),
      ),
    );
    _cubit.loadDailyPanchang(_effectiveDate, _apiLocationForName(_locName));
    _tick();
  }

  void _initStars() {
    final rng = math.Random();
    _stars.clear();
    for (int i = 0; i < 120; i++) {
      _stars.add(
        Star(
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          r: rng.nextDouble() * 0.8 + 0.2,
          alpha: rng.nextDouble(),
          dAlpha: (rng.nextDouble() - 0.5) * 0.003,
        ),
      );
    }
  }

  void _animateStars() {
    for (final s in _stars) {
      s.alpha = (s.alpha + s.dAlpha).clamp(0.0, 1.0);
      if (s.alpha <= 0 || s.alpha >= 1) s.dAlpha = -s.dAlpha;
    }
  }

  void _tick() {
    _vt = getVedicTime(DateTime.now(), _lon);
    setState(() => _vedicClockStr = '☽ ${_vt.formatted}');
  }

  @override
  void dispose() {
    _starCtrl.dispose();
    _handCtrl.dispose();
    _cubit.close();
    super.dispose();
  }

  // ── Active detail for the selected layer ──
  PanchangDetail _activeDetail(PanchangDailyModel day) {
    switch (_layer) {
      case 'nakshatra':
        return day.nakshatra;
      case 'yoga':
        return day.yoga;
      case 'karana':
        return day.karana;
      default:
        return day.tithi;
    }
  }

  double get _nowH {
    if (_selectedDate != null) return vedicDecimal(_selectedDate!, _lon);
    return _vt.decimal;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<TithiGhadiCubit, TithiGhadiState>(
        builder: (context, state) {
          // ── Find today's entry by matching dateAd ──
          final todayStr = [
            _effectiveDate.year.toString().padLeft(4, '0'),
            _effectiveDate.month.toString().padLeft(2, '0'),
            _effectiveDate.day.toString().padLeft(2, '0'),
          ].join('-');

          final currentDay = state.maybeWhen(
            loaded: (response) {
              for (final d in response.days) {
                if (d.dateAd == todayStr) return d;
              }
              return response.days.isNotEmpty ? response.days.first : null;
            },
            orElse: () => null,
          );

          String varaStr, nsStr, bsDateStr;

          final adDate = currentDay != null
              ? DateTime.parse(
                  currentDay.dateAd,
                ).add(const Duration(hours: 11, minutes: 30))
              : _effectiveDate;

          final bs = NepaliDateTime.fromDateTime(adDate);

          final month = kMonthsNS[bs.month - 1];
          final vara = currentDay?.vara.nameNp ?? '';

          varaStr = '$vara • $month';
          nsStr = 'ने.सं. ${toDevanagariNum(bs.year)} ${bs.month}';
          bsDateStr =
              '${bs.year}/${bs.month.toString().padLeft(2, '0')}/${bs.day.toString().padLeft(2, '0')}';

          return Scaffold(
            backgroundColor: kBg0,
            body: Stack(
              children: [
                CustomPaint(size: size, painter: StarfieldPainter(_stars)),
                SafeArea(
                  child: Column(
                    children: [
                      HomeHeader(
                        locName: _locName,
                        bsDateStr: bsDateStr,
                        onLocationTap: _showLocModal,
                        onDateTap: _showDateModal,
                      ),
                      TopInfoBar(
                        varaStr: varaStr,
                        nsStr: nsStr,
                        vedicClockStr: _vedicClockStr,
                      ),
                      Expanded(
                        child: currentDay != null
                            ? _buildDialArea(size, bsDateStr, currentDay)
                            : _buildLoading(state),
                      ),
                      if (currentDay != null)
                        LayerTabBar(
                          activeLayer: _layer,
                          day: currentDay,
                          onLayerChanged: (ly) => setState(() => _layer = ly),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDialArea(Size size, String bsDateStr, PanchangDailyModel day) {
    final cfg = kLayerConfigs[_layer]!;
    final detail = _activeDetail(day);
    final dialSize = math
        .min(size.width - 32, size.height - 200.0)
        .clamp(0.0, 520.0);

    return Center(
      child: SizedBox(
        width: dialSize,
        height: dialSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _handCtrl,
              builder: (ctx, _) {
                final rH =
                    calcRiseSet(_effectiveDate, _lat, _lon, _tz, true) ?? 6.25;
                final sH =
                    calcRiseSet(_effectiveDate, _lat, _lon, _tz, false) ??
                    18.55;
                return CustomPaint(
                  size: Size(dialSize, dialSize),
                  painter: DialPainter(
                    tithiDetail: day.tithi,
                    nakshatraDetail: day.nakshatra,
                    activeDetail: detail,
                    cfg: cfg,
                    nowH: _nowH,
                    riseH: rH,
                    setH: sH,
                    vedicTime: _vt,
                    isLive: _selectedDate == null,
                  ),
                );
              },
            ),
            CenterOverlay(
              size: dialSize * 0.62,
              detail: detail,
              layerConfig: cfg,
              vedicTime: _vt,
              bsDateStr: bsDateStr,
              isLive: _selectedDate == null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(TithiGhadiState state) {
    final isError = state.maybeWhen(error: () => true, orElse: () => false);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isError) ...[
            const Icon(Icons.wifi_off_outlined, color: kSlate, size: 36),
            const SizedBox(height: 12),
            const Text(
              'डेटा लोड हुन सकेन',
              style: TextStyle(color: kSlate, fontSize: 13),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _cubit.loadDailyPanchang(
                _effectiveDate,
                _apiLocationForName(_locName),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: kGold.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'पुनः प्रयास',
                  style: TextStyle(color: kGold, fontSize: 12),
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kGold.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'लोड हुँदैछ…',
              style: TextStyle(color: kSlate, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  String _apiLocationForName(String name) {
    const mapping = {
      'काठमाडौं': 'Kathmandu',
      'पोखरा': 'Pokhara',
      'भरतपुर': 'Bharatpur',
      'विराटनगर': 'Biratnagar',
      'ललितपुर': 'Lalitpur',
      'भक्तपुर': 'Bhaktapur',
      'बुटवल': 'Butwal',
      'धरान': 'Dharan',
    };
    return mapping[name] ?? name;
  }

  void _showLocModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => LocationModal(
        lat: _lat,
        lon: _lon,
        name: _locName,
        onApply: (lat, lon, name) {
          setState(() {
            _lat = lat;
            _lon = lon;
            _tz = (lon / 15 * 2).round() / 2;
            _locName = name;
          });
          _cubit.loadDailyPanchang(
            _effectiveDate,
            _apiLocationForName(_locName),
          );
        },
      ),
    );
  }

  void _showDateModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DateModal(
        selected: _selectedDate,
        onApply: (d) {
          setState(() => _selectedDate = d);
          _cubit.loadDailyPanchang(
            _effectiveDate,
            _apiLocationForName(_locName),
          );
        },
        onReset: () {
          setState(() => _selectedDate = null);
          _cubit.loadDailyPanchang(
            _effectiveDate,
            _apiLocationForName(_locName),
          );
        },
      ),
    );
  }
}
