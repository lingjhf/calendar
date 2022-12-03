import 'package:flutter/material.dart';
import 'base.dart';

class CalendarMultipleDatePicker extends BaseCalendarDatePicker {
  const CalendarMultipleDatePicker({
    super.key,
    required super.initDate,
    required super.dates,
    super.style,
    super.onInitDateChange,
    this.currentDates = const [],
    this.onChange,
  });

  final List<DateTime> currentDates;

  final ValueChanged<List<DateTime>>? onChange;

  @override
  State<StatefulWidget> createState() => _CalendarMultipleDatePicker();
}

class _CalendarMultipleDatePicker
    extends BaseCalendarDatePickerState<CalendarMultipleDatePicker> {
  Map<String, DateTime> currentDates = {};

  @override
  void initState() {
    super.initState();
    initCurrentDates(widget.currentDates);
  }

  void initCurrentDates(List<DateTime> dates) {
    var currentDates = <String, DateTime>{};
    for (var date in dates) {
      currentDates[date.toString()] = date;
    }
    this.currentDates = currentDates;
  }

  bool currentDatesContains(DateTime date) {
    return currentDates[date.toString()] != null;
  }

  void onSelectDate(DateTime date) {
    if (currentDatesContains(date)) {
      currentDates.remove(date.toString());
    } else {
      currentDates[date.toString()] = date;
    }
    if (date.month != initDate.month) {
      widget.onInitDateChange?.call(date);
      widget.onChange?.call(currentDates.values.toList());
      return;
    }
    setState(() {
      widget.onChange?.call(currentDates.values.toList());
    });
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    if (currentDatesContains(date)) {
      return const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
    }
    return const TextStyle(fontWeight: FontWeight.w600);
  }

  Color? getDateForegroundColor(Set<MaterialState> states, DateTime date) {
    if (currentDatesContains(date) ||
        date == DateUtils.dateOnly(DateTime.now())) {
      return widget.style?.accentColor;
    }
    if (date.month == initDate.month) {
      return widget.style?.primaryColor;
    }
    return widget.style?.secondaryColor;
  }

  Color? getDateBackground(Set<MaterialState> states, DateTime date) {
    if (currentDatesContains(date)) {
      return widget.style?.accentBackgroundColor;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisExtent: 36,
      ),
      children: [
        for (var date in dates)
          Center(
            child: SizedBox(
              width: 36,
              height: 32,
              child: TextButton(
                style: cellStyle.copyWith(
                  textStyle: MaterialStateProperty.resolveWith(
                    (states) => getDateTextStyle(states, date),
                  ),
                  shape: const MaterialStatePropertyAll(CircleBorder()),
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) => getDateForegroundColor(states, date),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => getDateBackground(states, date),
                  ),
                ),
                onPressed: () => onSelectDate(date),
                child: Text('${date.day}'),
              ),
            ),
          ),
      ],
    );
  }
}
