import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_utils/nepali_utils.dart';
import '../models/home_models.dart';

class DateModal extends StatefulWidget {
  final DateTime? selected;
  final void Function(DateTime?) onApply;
  final VoidCallback onReset;

  const DateModal({
    super.key,
    required this.selected,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<DateModal> createState() => _DateModalState();
}

class _DateModalState extends State<DateModal> {
  late DateTime _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.selected ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('मिति चुन्नुहोस्',
              style: TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: kBg0,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, color: kGold, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NepaliDateFormat('MMMM dd, yyyy').format(NepaliDateTime.fromDateTime(_picked)),
                          style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${_picked.year}/${_picked.month.toString().padLeft(2, '0')}/${_picked.day.toString().padLeft(2, '0')} AD',
                          style: TextStyle(color: kSlate.withValues(alpha: 0.6), fontSize: 11, fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_calendar_outlined, color: kCyan, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _shiftBtn('−७', -7),
              const SizedBox(width: 6),
              _shiftBtn('−१', -1),
              const SizedBox(width: 6),
              _shiftBtn('+१', 1),
              const SizedBox(width: 6),
              _shiftBtn('+७', 7),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kSlate,
                    side: BorderSide(color: kSlate.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('आज'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_picked);
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
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showPicker() async {
    final picked = await picker.showNepaliDatePicker(
      context: context,
      initialDate: NepaliDateTime.fromDateTime(_picked),
      firstDate: NepaliDateTime(1970),
      lastDate: NepaliDateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _picked = picked.toDateTime();
      });
    }
  }

  Widget _shiftBtn(String label, int days) {
    return GestureDetector(
      onTap: () => setState(() {
        _picked = _picked.add(Duration(days: days));
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kBg1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kGold.withOpacity(0.25)),
        ),
        child: Text(label, style: const TextStyle(color: kText, fontSize: 13)),
      ),
    );
  }
}
