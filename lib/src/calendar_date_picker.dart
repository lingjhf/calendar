import 'package:flutter/material.dart' hide CalendarDatePicker;

import '../calendar.dart';
import 'base.dart';
import 'extensions.dart';

class CalendarDatePicker extends BasePicker {
  CalendarDatePicker({
    super.key,
    super.initDate,
    super.currentDate,
    super.style,
    super.onChange,
    this.range = false,
    this.multiple = false,
    this.dateRange,
    this.dates = const [],
    this.dateRanges = const [],
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

  //是否可以选择日期范围
  final bool range;

  //是否可以多选日期
  final bool multiple;

  //range为true才能使用
  final DateTimeRange? dateRange;

  //multiple为true才能使用
  final List<DateTime> dates;

  final List<DateTimeRange> dateRanges;

  //todo
  final List<DateTime> allowDates;

  //todo
  final DateTime? minDate;

  //todo
  final DateTime? maxDate;

  //todo一个星期的开始
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
  late DateTime currentDate;
  ButtonStyle toolbarButtonSytle = const ButtonStyle(
    padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
  );
  ButtonStyle toolbarActionButtonStyle = const ButtonStyle(
    shape: MaterialStatePropertyAll(CircleBorder()),
    padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
    minimumSize: MaterialStatePropertyAll(Size(0, 0)),
  );

  @override
  void initState() {
    setWeekDays(widget.firstDayOfWeek);
    toolbarButtonSytle = toolbarButtonSytle.copyWith(
      foregroundColor: MaterialStatePropertyAll(widget.style?.primaryColor),
      overlayColor:
          MaterialStatePropertyAll(widget.style?.accentBackgroundColor),
    );
    toolbarActionButtonStyle = toolbarActionButtonStyle.copyWith(
      foregroundColor: MaterialStatePropertyAll(widget.style?.primaryColor),
      overlayColor:
          MaterialStatePropertyAll(widget.style?.accentBackgroundColor),
    );
    initDate = widget.initDate;
    currentDate = widget.currentDate;
    setDates();
    super.initState();
  }

  void setWeekDays(CalendarWeekDay weekDay) {
    var values = CalendarWeekDay.values.toList();
    final index = values.indexOf(weekDay);
    weekDays = [
      ...values.sublist(index).map((e) =>
          '${e.name.substring(0, 1).toUpperCase()}${e.name.substring(1, 3)}'),
      ...values.sublist(0, index).map((e) =>
          '${e.name.substring(0, 1).toUpperCase()}${e.name.substring(1, 3)}')
    ];
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

  void onSelectDate(DateTime date) {
    setState(() {
      if (date.month != initDate.month) {
        initDate = date;
        setDates();
      }
      currentDate = date;
      widget.onChange?.call(currentDate);
    });
  }

  Widget buildToolbar() {
    return Row(
      children: [
        TextButton(
          style: toolbarActionButtonStyle,
          onPressed: onPrevMonth,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 80,
          child: TextButton(
            style: toolbarButtonSytle,
            onPressed: () => widget.onMonthPick?.call(),
            child: Text(initDate.monthString()),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: toolbarActionButtonStyle,
          onPressed: onNextMonth,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
        const Spacer(),
        TextButton(
          style: toolbarActionButtonStyle,
          onPressed: onPrevYear,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 48,
          child: TextButton(
            style: toolbarButtonSytle,
            onPressed: () => widget.onYearPick?.call(),
            child: Text('${initDate.year}'),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: toolbarActionButtonStyle,
          onPressed: onNextYear,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }

  Widget buildWeekDays() {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: widget.style?.secondaryColor,
      ),
      child: Row(
        children: [
          for (final day in weekDays)
            Container(
              width: 36,
              height: 32,
              alignment: Alignment.center,
              child: Text(day),
            )
        ],
      ),
    );
  }

  Widget buildDates() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisExtent: 32,
      ),
      children: [
        for (var date in dates)
          TextButton(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.resolveWith((states) {
                if (date == DateUtils.dateOnly(currentDate)) {
                  return const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  );
                }
                return const TextStyle(fontWeight: FontWeight.w600);
              }),
              shape: const MaterialStatePropertyAll(CircleBorder()),
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                if (date == DateUtils.dateOnly(currentDate) ||
                    date == DateUtils.dateOnly(DateTime.now())) {
                  return widget.style?.accentColor;
                }
                if (date.month == initDate.month) {
                  return widget.style?.primaryColor;
                }
                return widget.style?.secondaryColor;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (date == DateUtils.dateOnly(currentDate)) {
                  return widget.style?.accentBackgroundColor;
                }
                return null;
              }),
              overlayColor: MaterialStateProperty.resolveWith((states) {
                return widget.style?.accentBackgroundColor;
              }),
            ),
            onPressed: () => onSelectDate(date),
            child: Text('${date.day}'),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildToolbar(),
        buildWeekDays(),
        Expanded(child: buildDates())
      ],
    );
  }
}
