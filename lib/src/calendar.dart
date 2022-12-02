import 'package:flutter/material.dart' hide CalendarDatePicker;

import 'calendar_month_picker.dart';
import 'calendar_year_picker.dart';
import 'enums.dart';
import 'calendar_date_picker.dart';
import 'theme.dart';

class Calendar extends StatefulWidget {
  Calendar({
    super.key,
    DateTime? initDate,
    DateTime? currentDate,
    this.allowDates = const [],
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = CalendarWeekDay.sunday,
    this.disable = false,
    this.readonly = false,
    this.mode = CalendarMode.day,
    this.style,
    this.onDateChange,
    this.onDateRangeChange,
    this.onMultipleChange,
    this.onMultipleRangeChange,
  })  : currentDate = currentDate ?? DateTime.now(),
        initDate = initDate ?? DateTime.now();

  final DateTime initDate;

  final DateTime currentDate;

  final List<DateTime> allowDates;

  final DateTime? minDate;

  final DateTime? maxDate;

  //一个星期的开始
  final CalendarWeekDay firstDayOfWeek;

  //是否禁用
  final bool disable;

  //是否只读
  final bool readonly;

  final CalendarMode mode;

  final CalendarStyle? style;

  final ValueChanged<DateTime>? onDateChange;

  final ValueChanged<DateTimeRange>? onDateRangeChange;

  final ValueChanged<List<DateTime>>? onMultipleChange;

  final ValueChanged<List<DateTimeRange>>? onMultipleRangeChange;

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime initDate;
  late DateTime currentDate;
  CalendarMode mode = CalendarMode.day;

  @override
  void initState() {
    initDate = widget.currentDate;
    currentDate = widget.currentDate;
    mode = widget.mode;
    super.initState();
  }

  void onYearPick() {
    setState(() {
      mode = CalendarMode.year;
    });
  }

  void onMonthPick() {
    setState(() {
      mode = CalendarMode.month;
    });
  }

  void onDateChange(DateTime date) {
    currentDate = date;
    initDate = date;
    widget.onDateChange?.call(date);
  }

  void onMonthChange(DateTime date) {
    setState(() {
      initDate = date;
      mode = CalendarMode.day;
    });
  }

  void onYearChange(DateTime date) {
    setState(() {
      initDate = date;
      mode = CalendarMode.day;
    });
  }

  Widget buildPicker(CalendarStyle style) {
    switch (mode) {
      case CalendarMode.day:
        return CalendarDatePicker(
          initDate: initDate,
          currentDate: currentDate,
          style: style,
          onYearPick: onYearPick,
          onMonthPick: onMonthPick,
          onChange: onDateChange,
          onDateRangeChange: widget.onDateRangeChange,
          onMultipleChange: widget.onMultipleChange,
        );
      case CalendarMode.month:
        return CalendarMonthPicker(
          initDate: initDate,
          currentDate: currentDate,
          style: style,
          onChange: onMonthChange,
          onYearPick: onYearPick,
        );
      case CalendarMode.year:
        return CalendarYearPicker(
          initDate: initDate,
          currentDate: currentDate,
          style: style,
          onChange: onYearChange,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        Theme.of(context).extension<CalendarStyle>() ??
        CalendarStyle();

    return DefaultTextStyle(
      style: TextStyle(color: style.primaryColor),
      child: Container(
        padding: style.padding,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: style.borderRadius,
        ),
        child: SizedBox(
          width: 7 * 36,
          height: 8 * 32,
          child: buildPicker(style),
        ),
      ),
    );
  }
}
