import 'package:flutter/material.dart';

import 'base.dart';

class CalendarSingleDatePicker extends BaseCalendarDatePicker {
  const CalendarSingleDatePicker({
    super.key,
    super.readonly,
    required super.initDate,
    required super.dates,
    super.allowDates,
    super.style,
    super.onInitDateChange,
    this.currentDate,
    this.onChange,
  });

  final DateTime? currentDate;

  final ValueChanged<DateTime?>? onChange;

  @override
  State<StatefulWidget> createState() => _CalendarSingleDatePickerState();
}

class _CalendarSingleDatePickerState
    extends BaseCalendarDatePickerState<CalendarSingleDatePicker> {
  DateTime? currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = widget.currentDate;
  }

  bool isCurrentDate(DateTime date) {
    return currentDate != null && date == DateUtils.dateOnly(currentDate!);
  }

  //点击选择日期
  void onSelectDate(DateTime date) {
    if (widget.readonly) return;
    if (widget.allowDates.isNotEmpty) {
      if (!widget.allowDates.contains(date)) {
        return;
      }
    }
    currentDate = date == currentDate ? null : date;
    if (date.month != initDate.month) {
      widget.onInitDateChange?.call(date);
      widget.onChange?.call(currentDate);
      return;
    }
    setState(() {
      widget.onChange?.call(currentDate);
    });
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentDate(date);
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
    final isAccent =
        isCurrentDate(date) || date == DateUtils.dateOnly(DateTime.now());
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
    final isAccent = isCurrentDate(date);
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
