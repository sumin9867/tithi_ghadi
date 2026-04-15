import 'package:flutter/material.dart';
import 'package:tithi_gadhi/features/home/domain/panchang_daily_model.dart';
import '../models/home_models.dart';

class SankalpPanel extends StatelessWidget {
  final PanchangDailyModel day;

  const SankalpPanel({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('संकल्प',
                style: TextStyle(color: kGold, fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            const Text('यो सुविधा छिट्टै आउँदैछ।',
                style: TextStyle(color: kSlate, fontSize: 14)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kBg1.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kGold.withValues(alpha: 0.2)),
              ),
              child: Text(
                'आज ${day.vara.nameNp}\n${day.tithi.nameNp}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kText, fontSize: 13, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
