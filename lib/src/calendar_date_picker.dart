import 'package:flutter/material.dart' hide CalendarDatePicker;

import '../calendar.dart';
import 'base.dart';
import 'calendar_single_date_range_picker.dart';
import 'calendar_multiple_date_picker.dart';
import 'calendar_single_date_picker.dart';
import 'calendar_week.dart';
import 'extensions.dart';

class CalendarDatePicker extends BasePicker {
  CalendarDatePicker({
    super.key,
    super.initDate,
    super.currentDate,
    super.style,
    super.onChange,
    this.readonly = false,
    this.range = false,
    this.multiple = false,
    this.currentDates = const [],
    this.currentDateRange,
    this.currentDateRanges = const [],
    this.allowDates = const [],
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = CalendarWeekDay.sunday,
    this.onDateRangeChange,
    this.onMultipleChange,
    this.onMultipleRangeChange,
    this.onYearChange,
    this.onMonthChange,
    this.onMonthPick,
    this.onYearPick,
  });

  final bool readonly;

  //是否可以选择日期范围
  final bool range;

  //是否可以多选日期
  final bool multiple;

  //multiple为true才能使用
  final List<DateTime> currentDates;

  //range为true才能使用
  final DateTimeRange? currentDateRange;

  //range和multiple同时为true才能使用
  final List<DateTimeRange> currentDateRanges;

  //todo
  final List<DateTime> allowDates;

  //todo
  final DateTime? minDate;

  //todo
  final DateTime? maxDate;

  //一个星期的开始
  final CalendarWeekDay firstDayOfWeek;

  //日期范围变化回调函数
  final ValueChanged<DateTimeRange>? onDateRangeChange;

  //多日期变化回调函数
  final ValueChanged<List<DateTime>>? onMultipleChange;

  final ValueChanged<List<DateTimeRange>>? onMultipleRangeChange;

  final ValueChanged<DateTime>? onYearChange;

  final ValueChanged<DateTime>? onMonthChange;

  final VoidCallback? onYearPick;

  final VoidCallback? onMonthPick;

  @override
  State<StatefulWidget> createState() => _CalendarDatePickerState();
}

class _CalendarDatePickerState extends State<CalendarDatePicker> {
  List<String> weekDays = [];

  List<DateTime> dates = [];
  late DateTime initDate;
  DateTime? currentDate;
  List<DateTime> currentDates = [];
  DateTimeRange? currentDateRange;

  ButtonStyle titleButtonSytle = const ButtonStyle(
    padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
  );

  ButtonStyle actionButtonStyle = const ButtonStyle(
    shape: MaterialStatePropertyAll(CircleBorder()),
    padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
    minimumSize: MaterialStatePropertyAll(Size(0, 0)),
  );

  @override
  void initState() {
    initDate = widget.initDate;
    currentDate = widget.currentDate;
    currentDates = widget.currentDates;
    currentDateRange = widget.currentDateRange;
    setDates();
    super.initState();
  }

  void setDates() {
    final dates = <DateTime>[];
    final day1 = DateTime(initDate.year, initDate.month, 1);
    if (day1.weekday != widget.firstDayOfWeek.value) {
      var tempDate = day1;
      while (true) {
        tempDate = tempDate.subtract(const Duration(days: 1));
        dates.insert(0, tempDate);
        if (tempDate.weekday == widget.firstDayOfWeek.value) break;
      }
    }
    var rowCount = 0;
    var tempDate = day1;
    while (rowCount < 6) {
      dates.add(tempDate);
      tempDate = tempDate.add(const Duration(days: 1));
      if (tempDate.weekday == widget.firstDayOfWeek.value) {
        rowCount++;
      }
    }
    this.dates = dates;
  }

  //下一年
  void onNextYear() {
    setState(() {
      initDate = initDate.addYear();
      setDates();
      widget.onYearChange?.call(initDate);
    });
  }

  //上一年
  void onPrevYear() {
    setState(() {
      initDate = initDate.subtractYear();
      setDates();
      widget.onYearChange?.call(initDate);
    });
  }

  //下一个月
  void onNextMonth() {
    setState(() {
      initDate = initDate.addMonth();
      setDates();
      widget.onMonthChange?.call(initDate);
    });
  }

  //上一个月
  void onPrevMonth() {
    setState(() {
      initDate = initDate.subtractMonth();
      setDates();
      widget.onMonthChange?.call(initDate);
    });
  }

  void onInitDateChange(DateTime date) {
    initDate = date;
    setState(() {
      setDates();
    });
  }

  void onSingleDateChange(DateTime? date) {
    currentDate = date;
  }

  void onMultipleDateChange(List<DateTime> dates) {
    currentDates = dates;
  }

  void onSingleDateRangeChange(DateTimeRange? dateRange) {
    currentDateRange = dateRange;
  }

  Widget buildDatePicker() {
    if (widget.multiple) {
      return CalendarMultipleDatePicker(
        readonly: widget.readonly,
        initDate: initDate,
        currentDates: currentDates,
        dates: dates,
        allowDates: widget.allowDates,
        style: widget.style,
        onInitDateChange: onInitDateChange,
        onChange: onMultipleDateChange,
      );
    }
    if (widget.range) {
      return CalendarSingleDateRangePicker(
        readonly: widget.readonly,
        initDate: initDate,
        dates: dates,
        style: widget.style,
        onInitDateChange: onInitDateChange,
        onChange: onSingleDateRangeChange,
      );
    }
    return CalendarSingleDatePicker(
      readonly: widget.readonly,
      initDate: initDate,
      currentDate: currentDate,
      dates: dates,
      allowDates: widget.allowDates,
      style: widget.style,
      onInitDateChange: onInitDateChange,
      onChange: onSingleDateChange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.readonly)
          SizedBox(
            height: 32,
            child: CalendarDatePickerToolbar(
              date: initDate,
              style: widget.style,
              onMonthPick: () => widget.onMonthPick?.call(),
              onYearPick: () => widget.onYearPick?.call(),
              onPrevMonth: onPrevMonth,
              onNextMonth: onNextMonth,
              onPrevYear: onPrevYear,
              onNextYear: onNextYear,
            ),
          ),
        CalendarWeek(
          firstDayOfWeek: widget.firstDayOfWeek,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: widget.style?.secondaryColor,
          ),
        ),
        Expanded(child: buildDatePicker())
      ],
    );
  }
}

class CalendarDatePickerToolbar extends StatelessWidget {
  const CalendarDatePickerToolbar({
    super.key,
    required this.date,
    this.style,
    required this.onMonthPick,
    required this.onYearPick,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onPrevYear,
    required this.onNextYear,
  });

  final DateTime date;

  final CalendarStyle? style;

  final VoidCallback onMonthPick;

  final VoidCallback onYearPick;

  final VoidCallback onNextYear;

  final VoidCallback onPrevYear;

  final VoidCallback onNextMonth;

  final VoidCallback onPrevMonth;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(style?.primaryColor),
      overlayColor: MaterialStatePropertyAll(style?.accentBackgroundColor),
    );

    ButtonStyle titleButtonSytle = buttonStyle.copyWith(
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
    );

    ButtonStyle actionButtonStyle = buttonStyle.copyWith(
      shape: const MaterialStatePropertyAll(CircleBorder()),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
      minimumSize: const MaterialStatePropertyAll(Size(0, 0)),
    );

    return Row(
      children: [
        TextButton(
          style: actionButtonStyle,
          onPressed: onPrevMonth,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 80,
          child: TextButton(
            style: titleButtonSytle,
            onPressed: onMonthPick,
            child: Text(date.monthString()),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: actionButtonStyle,
          onPressed: onNextMonth,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
        const Spacer(),
        TextButton(
          style: actionButtonStyle,
          onPressed: onPrevYear,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 48,
          child: TextButton(
            style: titleButtonSytle,
            onPressed: onYearPick,
            child: Text('${date.year}'),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: actionButtonStyle,
          onPressed: onNextYear,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
