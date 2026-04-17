import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:tithi_gadhi/features/home/presentation/models/home_models.dart';

const List<String> kWeekDaysShortNP = ['आ', 'सो', 'मं', 'बु', 'बि', 'शु', 'श'];

class DateModal extends StatefulWidget {
  final DateTime? selected;
  final void Function(DateTime) onApply;
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
  late int _viewBsYear;
  late int _viewBsMonth;

  late int _selBsYear;
  late int _selBsMonth;
  late int _selBsDay;

  late int _hour;
  late int _minute;
  late bool _isPM;

  @override
  void initState() {
    super.initState();

    final base = widget.selected ?? DateTime.now();
    final bs = base.toNepaliDateTime();

    _selBsYear = bs.year;
    _selBsMonth = bs.month;
    _selBsDay = bs.day;

    _viewBsYear = bs.year;
    _viewBsMonth = bs.month;

    final now = DateTime.now();
    int h = now.hour;
    _minute = now.minute;
    _isPM = h >= 12;
    h = h % 12;
    _hour = h == 0 ? 12 : h;
  }

  DateTime get _combined {
    final h24 = _isPM ? (_hour % 12) + 12 : _hour % 12;
    final nepDt = NepaliDateTime(
      _selBsYear,
      _selBsMonth,
      _selBsDay,
      h24,
      _minute,
    );
    final ad = nepDt.toDateTime();
    return DateTime(ad.year, ad.month, ad.day, h24, _minute);
  }

  String get _metaString {
    final npMonth = kMonthsNS[_selBsMonth - 1];
    final ampm = _isPM ? 'PM' : 'AM';
    return 'ने.सं. $_selBsYear $npMonth $_selBsDay  |  '
        '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')} $ampm';
  }

  int _daysInBsMonth(int year, int month) =>
      NepaliDateTime(year, month).totalDays;

  int _firstWeekdayOfBsMonth(int year, int month) {
    final ad = NepaliDateTime(year, month, 1).toDateTime();
    return ad.weekday % 7;
  }

  void _changeMonth(int delta) {
    setState(() {
      _viewBsMonth += delta;
      if (_viewBsMonth > 12) {
        _viewBsMonth = 1;
        _viewBsYear++;
      } else if (_viewBsMonth < 1) {
        _viewBsMonth = 12;
        _viewBsYear--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        decoration: const BoxDecoration(
          color: kBg1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildHandle(),
            _buildHeader(context),
            const SizedBox(height: 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCalendar(),
                    const SizedBox(height: 10),
                    _buildTimePicker(),
                    const SizedBox(height: 10),
                    _buildMetaBar(),
                    const SizedBox(height: 14),
                    _buildApplyButton(context),
                    const SizedBox(height: 8),
                    _buildResetButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() => Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 4),
    child: Center(
      child: Container(
        width: 40,
        height: 3,
        decoration: BoxDecoration(
          color: kSlate.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ),
  );

  Widget _buildHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 12, 10),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: kGold.withValues(alpha: 0.15),
            border: Border.all(color: kGold.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.calendar_month_rounded,
            color: kGold,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'मिति छान्नुहोस्',
          style: TextStyle(
            color: kText,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kSlate.withValues(alpha: 0.35)),
            ),
            child: const Icon(Icons.close, color: kSlate, size: 15),
          ),
        ),
      ],
    ),
  );

  Widget _buildCalendar() {
    return _GoldCard(
      child: Column(
        children: [
          _buildMonthNav(),
          const SizedBox(height: 6),
          _buildDayHeaders(),
          const SizedBox(height: 4),
          _buildDayGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthNav() {
    final npMonth = kMonthsNS[_viewBsMonth - 1];
    final label = '$npMonth $_viewBsYear';
    return Row(
      children: [
        _NavBtn(
          icon: Icons.chevron_left_rounded,
          onTap: () => _changeMonth(-1),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _NavBtn(
          icon: Icons.chevron_right_rounded,
          onTap: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildDayHeaders() => Row(
    children: kWeekDaysShortNP
        .map(
          (d) => Expanded(
            child: Text(
              d,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kSlate,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ),
        )
        .toList(),
  );

  Widget _buildDayGrid() {
    final firstWd = _firstWeekdayOfBsMonth(_viewBsYear, _viewBsMonth);
    final daysInM = _daysInBsMonth(_viewBsYear, _viewBsMonth);
    final todayBs = DateTime.now().toNepaliDateTime();
    final rows = ((firstWd + daysInM) / 7).ceil();

    return Column(
      children: List.generate(rows, (r) {
        return Row(
          children: List.generate(7, (c) {
            final idx = r * 7 + c;
            final day = idx - firstWd + 1;

            if (day < 1 || day > daysInM) {
              return const Expanded(child: SizedBox(height: 34));
            }

            final isSelected =
                day == _selBsDay &&
                _viewBsMonth == _selBsMonth &&
                _viewBsYear == _selBsYear;

            final isToday =
                day == todayBs.day &&
                _viewBsMonth == todayBs.month &&
                _viewBsYear == todayBs.year;

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _selBsDay = day;
                  _selBsMonth = _viewBsMonth;
                  _selBsYear = _viewBsYear;
                }),
                child: Container(
                  height: 34,
                  margin: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? kGold : Colors.transparent,
                    border: isToday && !isSelected
                        ? Border.all(
                            color: kGold.withValues(alpha: 0.6),
                            width: 1,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? kBg0
                          : isToday
                          ? kGold
                          : kText,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildTimePicker() {
    return _GoldCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'समय',
            style: TextStyle(color: kSlate, fontSize: 10, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimeSpinner(
                value: _hour,
                min: 1,
                max: 12,
                onChanged: (v) => setState(() => _hour = v),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kGold,
                    height: 1.1,
                  ),
                ),
              ),
              _TimeSpinner(
                value: _minute,
                min: 0,
                max: 59,
                onChanged: (v) => setState(() => _minute = v),
                circular: true,
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  _AmPmBtn(
                    label: 'AM',
                    active: !_isPM,
                    onTap: () => setState(() => _isPM = false),
                  ),
                  const SizedBox(height: 5),
                  _AmPmBtn(
                    label: 'PM',
                    active: _isPM,
                    onTap: () => setState(() => _isPM = true),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaBar() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: kBg1,
      border: Border.all(color: kGold.withValues(alpha: 0.18)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      _metaString,
      textAlign: TextAlign.center,
      style: const TextStyle(color: kGoldLt, fontSize: 12),
    ),
  );

  Widget _buildApplyButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        widget.onApply(_combined);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kGold,
        foregroundColor: kBg0,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'मिति लागू गर्नुहोस्',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
  );

  Widget _buildResetButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 44,
    child: OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
        widget.onReset();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: kSlate,
        side: BorderSide(color: kSlate.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'आज फर्कनुहोस्',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class _GoldCard extends StatelessWidget {
  final Widget child;
  const _GoldCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: kBg1,
      border: Border.all(color: kGold.withValues(alpha: 0.22)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: child,
  );
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: kGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Icon(icon, color: kGold, size: 18),
    ),
  );
}

class _TimeSpinner extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final bool circular;
  final void Function(int) onChanged;

  const _TimeSpinner({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.circular = false,
  });

  void _increment() {
    if (circular) {
      onChanged(value >= max ? min : value + 1);
    } else {
      if (value < max) onChanged(value + 1);
    }
  }

  void _decrement() {
    if (circular) {
      onChanged(value <= min ? max : value - 1);
    } else {
      if (value > min) onChanged(value - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _increment,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: kGold,
              size: 20,
            ),
          ),
        ),
        Container(
          width: 54,
          height: 46,
          decoration: BoxDecoration(
            color: kBg1,
            border: Border.all(color: kGold.withValues(alpha: 0.28)),
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: kText,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        GestureDetector(
          onTap: _decrement,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: kGold,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmPmBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _AmPmBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? kGold : kBg1,
        border: Border.all(
          color: active ? kGold : kGold.withValues(alpha: 0.22),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: active ? kBg0 : kSlate,
        ),
      ),
    ),
  );
}
