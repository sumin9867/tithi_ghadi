import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/home_models.dart';

class LocationModal extends StatefulWidget {
  final double lat;
  final double lon;
  final String name;
  final void Function(double lat, double lon, String name) onApply;

  const LocationModal({
    super.key,
    required this.lat,
    required this.lon,
    required this.name,
    required this.onApply,
  });

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _NominatimResult {
  final String displayName;
  final String shortName;
  final double lat;
  final double lon;

  const _NominatimResult({
    required this.displayName,
    required this.shortName,
    required this.lat,
    required this.lon,
  });

  factory _NominatimResult.fromJson(Map<String, dynamic> json) {
    final display = json['display_name'] as String? ?? '';
    final short = display.split(',').first.trim();
    return _NominatimResult(
      displayName: display,
      shortName: short,
      lat: double.tryParse(json['lat'] as String? ?? '0') ?? 0,
      lon: double.tryParse(json['lon'] as String? ?? '0') ?? 0,
    );
  }
}

class _LocationModalState extends State<LocationModal>
    with SingleTickerProviderStateMixin {
  late double _lat, _lon;
  late String _selectedName;
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  List<_NominatimResult> _results = [];
  bool _isLoading = false;
  bool _showResults = false;
  Timer? _debounce;
  Timer? _timeTimer;
  String _localTime = '';

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _lat = widget.lat;
    _lon = widget.lon;
    _selectedName = widget.name;
    _searchCtrl.text = widget.name;

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _results.isNotEmpty) {
        setState(() => _showResults = true);
        _animCtrl.forward();
      }
    });

    _updateLocalTime();
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateLocalTime();
    });
  }

  void _updateLocalTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final second = now.second;

    final nepaliHour = _convertToNepali(hour);
    final nepaliMinute = _convertToNepali(minute);
    final nepaliSecond = _convertToNepali(second);

    final period = hour < 12 ? 'पूर्वाह्न' : 'अपराह्न';

    if (mounted) {
      setState(() {
        _localTime = '$nepaliHour:$nepaliMinute:$nepaliSecond $period';
      });
    }
  }

  String _convertToNepali(int num) {
    const nepaliDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    return num.toString()
        .split('')
        .map((d) => nepaliDigits[int.parse(d)])
        .join();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _timeTimer?.cancel();
    _searchCtrl.dispose();
    _focusNode.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        _results = [];
        _showResults = false;
      });
      _animCtrl.reverse();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?format=json&limit=6&q=${Uri.encodeComponent(query)}',
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'AstroApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final results = data.map((e) => _NominatimResult.fromJson(e)).toList();
        if (mounted) {
          setState(() {
            _results = results;
            _showResults = results.isNotEmpty;
            _isLoading = false;
          });
          if (results.isNotEmpty) _animCtrl.forward();
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  void _selectResult(_NominatimResult result) {
    setState(() {
      _lat = result.lat;
      _lon = result.lon;
      _selectedName = result.shortName;
      _searchCtrl.text = result.shortName;
      _showResults = false;
      _results = [];
    });
    _animCtrl.reverse();
    _focusNode.unfocus();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final newPermission = await Geolocator.requestPermission();
        if (newPermission != LocationPermission.whileInUse &&
            newPermission != LocationPermission.always) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _lat = position.latitude;
        _lon = position.longitude;
        _selectedName = 'Current Location';
        _searchCtrl.text = 'Current Location';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: const BoxDecoration(
        color: kBg0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('📍', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    'स्थान चयन',
                    style: TextStyle(
                      color: kText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A2E47),
                    border: Border.all(color: kGold, width: 1.2),
                  ),
                  child: const Center(
                    child: Text(
                      '✕',
                      style: TextStyle(
                        color: kGold,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFB49650).withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: kText, fontSize: 14),
              cursorColor: kGold,
              decoration: InputDecoration(
                hintText: 'स्थान खोज्नुहोस्...',
                hintStyle: TextStyle(
                  color: kSlate.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: kGold.withValues(alpha: 0.7),
                  size: 18,
                ),
                suffixIcon: _isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              kGold.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
          if (_showResults) ...[
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1628),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: kGold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: kGold.withValues(alpha: 0.1),
                      indent: 12,
                      endIndent: 12,
                    ),
                    itemBuilder: (context, i) {
                      final r = _results[i];
                      return InkWell(
                        onTap: () => _selectResult(r),
                        splashColor: kCyan.withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '📍',
                                style: TextStyle(fontSize: 14, color: kGold),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.shortName,
                                      style: const TextStyle(
                                        color: kText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      r.displayName,
                                      style: TextStyle(
                                        color: kSlate.withValues(alpha: 0.6),
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${r.lat.toStringAsFixed(2)}°',
                                style: const TextStyle(
                                  color: kCyan,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: kBg0,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kGold.withValues(alpha: 0.2), width: 1),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  painter: _NepalMapPainter(lat: _lat, lon: _lon),
                  child: Container(),
                ),
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${_lat.toStringAsFixed(2)}°N · ${_lon.toStringAsFixed(2)}°E',
                      style: const TextStyle(
                        color: kCyan,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'स्थानको स्थानीय समय: $_localTime',
              style: const TextStyle(
                color: kCyan,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _GoldButton(
            icon: Icons.gps_fixed_rounded,
            label: 'हालको स्थान प्रयोग गर्नुहोस्',
            onTap: _getCurrentLocation,
            outlined: true,
          ),
          const SizedBox(height: 10),
          _GoldButton(
            label: 'स्थान लागू गर्नुहोस्',
            onTap: () {
              widget.onApply(_lat, _lon, _selectedName);
              Navigator.pop(context);
            },
            outlined: false,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _NepalMapPainter extends CustomPainter {
  final double lat;
  final double lon;

  _NepalMapPainter({required this.lat, required this.lon});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    _drawNepalOutline(canvas, size, paint);
    _drawPin(canvas, size);
  }

  void _drawNepalOutline(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    const points = [
      (0.2, 0.3),
      (0.4, 0.25),
      (0.6, 0.3),
      (0.8, 0.35),
      (0.85, 0.5),
      (0.8, 0.65),
      (0.6, 0.7),
      (0.4, 0.75),
      (0.2, 0.7),
      (0.15, 0.5),
    ];

    path.moveTo(points[0].$1 * size.width, points[0].$2 * size.height);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].$1 * size.width, points[i].$2 * size.height);
    }
    path.close();

    canvas.drawPath(path, paint);

    final featurePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.08)
      ..strokeWidth = 0.3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.45),
      size.width * 0.08,
      featurePaint,
    );
  }

  void _drawPin(Canvas canvas, Size size) {
    final normalizedX = ((lon - 80) / 8).clamp(0.0, 1.0);
    final normalizedY = ((30 - lat) / 4).clamp(0.0, 1.0);

    final pinX = normalizedX * size.width;
    final pinY = normalizedY * size.height;

    final pinPaint = Paint()
      ..color = const Color(0xFFFF6B4D)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(pinX, pinY), 6, pinPaint);

    final outlinePaint = Paint()
      ..color = const Color(0xFFFF8C66)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(pinX, pinY), 6, outlinePaint);
  }

  @override
  bool shouldRepaint(_NepalMapPainter oldDelegate) {
    return oldDelegate.lat != lat || oldDelegate.lon != lon;
  }
}

class _GoldButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool outlined;

  const _GoldButton({
    required this.label,
    required this.onTap,
    required this.outlined,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: kGold,
                side: BorderSide(
                  color: kGold.withValues(alpha: 0.6),
                  width: 1.2,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: kGold),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold.withValues(alpha: 0.12),
                foregroundColor: kGold,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: kGold.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
