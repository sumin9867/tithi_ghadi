import 'package:flutter/material.dart';
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

class _LocationModalState extends State<LocationModal> {
  late double _lat, _lon;
  final _searchCtrl = TextEditingController();

  static const _presets = [
    ('काठमाडौं', 27.7172, 85.3240),
    ('पोखरा', 28.2096, 83.9856),
    ('भरतपुर', 27.6767, 84.4300),
    ('विराटनगर', 26.4525, 87.2718),
    ('ललितपुर', 27.6644, 85.3188),
    ('भक्तपुर', 27.6710, 85.4298),
    ('बुटवल', 27.7006, 83.4532),
    ('धरान', 26.8120, 87.2840),
  ];

  @override
  void initState() {
    super.initState();
    _lat = widget.lat;
    _lon = widget.lon;
    _searchCtrl.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('स्थान चुन्नुहोस्',
              style: TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kBg0,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kGold.withOpacity(0.3)),
            ),
            child: Text(
              '${_lat.toStringAsFixed(4)}°N · ${_lon.toStringAsFixed(4)}°E',
              style: const TextStyle(color: kCyan, fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(height: 14),
          const Text('सुझावित स्थानहरू:', style: TextStyle(color: kSlate, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presets.map((p) {
              final isSelected = (p.$2 - _lat).abs() < 0.01 && (p.$3 - _lon).abs() < 0.01;
              return GestureDetector(
                onTap: () => setState(() {
                  _lat = p.$2;
                  _lon = p.$3;
                  _searchCtrl.text = p.$1;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? kCyan.withOpacity(0.15) : kBg0,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? kCyan : kGold.withOpacity(0.25),
                    ),
                  ),
                  child: Text(p.$1,
                      style: TextStyle(color: isSelected ? kCyan : kText, fontSize: 12)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_lat, _lon, _searchCtrl.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kCyan.withOpacity(0.15),
                foregroundColor: kCyan,
                side: BorderSide(color: kCyan.withOpacity(0.4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('लागू गर्नुहोस्'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
