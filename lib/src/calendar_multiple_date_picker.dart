import 'package:flutter/material.dart';
import 'base.dart';

class CalendarMultipleDatePicker extends BaseCalendarDatePicker {
  const CalendarMultipleDatePicker({
    super.key,
    super.readonly,
    required super.initDate,
    required super.dates,
    super.allowDates,
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
    return currentDates.containsKey(date.toString());
  }

  void onSelectDate(DateTime date) {
    if (widget.readonly) return;
    if (widget.allowDates.isNotEmpty && !widget.allowDates.contains(date)) {
      return;
    }
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
    final isAccent = currentDatesContains(date);
    if (widget.allowDates.isNotEmpty) {
      if (isAccent && widget.allowDates.contains(date)) {
        return const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        );
      }
      return const TextStyle(fontWeight: FontWeight.w600);
    }
    if (isAccent) {
      return const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
    }
    return const TextStyle(fontWeight: FontWeight.w600);
  }

  Color? getDateForegroundColor(Set<MaterialState> states, DateTime date) {
    final isAccent = currentDatesContains(date) ||
        date == DateUtils.dateOnly(DateTime.now());
    if (widget.allowDates.isNotEmpty) {
      if (widget.allowDates.contains(date)) {
        if (isAccent) return widget.style?.accentColor;
        return widget.style?.primaryColor;
      }
      return widget.style?.secondaryColor;
    }
    if (isAccent) {
      return widget.style?.accentColor;
    }
    if (date.month == initDate.month) {
      return widget.style?.primaryColor;
    }
    return widget.style?.secondaryColor;
  }

  Color? getDateBackground(Set<MaterialState> states, DateTime date) {
    final isAccent = currentDatesContains(date);
    if (widget.allowDates.isNotEmpty) {
      if (isAccent && widget.allowDates.contains(date)) {
        return widget.style?.accentBackgroundColor;
      }
      return null;
    }
    if (isAccent) {
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
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) => getDateForegroundColor(states, date),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => getDateBackground(states, date),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith(
                    (states) => getDateOverlayColor(states, date),
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
