import 'base.dart';
import 'package:flutter/material.dart';
import 'extensions.dart';

class CalendarSingleDateRangePicker extends BaseCalendarDatePicker {
  const CalendarSingleDateRangePicker({
    super.key,
    required super.initDate,
    required super.dates,
    super.style,
    super.onInitDateChange,
    this.currentDateRange,
    this.onChange,
  });

  final DateTimeRange? currentDateRange;

  final ValueChanged<DateTimeRange?>? onChange;

  @override
  State<StatefulWidget> createState() => _CalendarSingleDateRangePickerState();
}

class _CalendarSingleDateRangePickerState
    extends BaseCalendarDatePickerState<CalendarSingleDateRangePicker> {
  DateTimeRange? currentDateRange;

  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    currentDateRange = widget.currentDateRange;
  }

  bool isStartOrEndDate(DateTime date) {
    if (date == currentDateRange?.start || date == currentDateRange?.end) {
      return true;
    }
    if (date == startDate) {
      return true;
    }

    return false;
  }

  bool isStartAndEndDateEqual(DateTime date) {
    return currentDateRange?.start == currentDateRange?.end &&
        currentDateRange?.end == date;
  }

  void onSelectDate(DateTime date) {
    if (startDate == null &&
        currentDateRange != null &&
        currentDateRange!.contains(date)) {
      startDate = null;
      currentDateRange = null;
    } else if (startDate != null) {
      currentDateRange = date.isBefore(startDate!)
          ? DateTimeRange(start: date, end: startDate!)
          : DateTimeRange(start: startDate!, end: date);
      startDate = null;
    } else {
      startDate = date;
    }
    if (date.month != initDate.month) {
      widget.onInitDateChange?.call(date);
      widget.onChange?.call(currentDateRange);
      return;
    }
    setState(() {
      widget.onChange?.call(currentDateRange);
    });
  }

  BoxDecoration? getDateBoxDecoration(DateTime date) {
    if (currentDateRange == null) return null;
    if (isStartAndEndDateEqual(date)) {
      return null;
    }
    LinearGradient? gradient;
    if (date == currentDateRange!.start) {
      gradient = LinearGradient(
        colors: [Colors.transparent, widget.style!.accentBackgroundColor],
        stops: const [0.5, 0.5],
      );
    }
    if (date == currentDateRange!.end) {
      gradient = LinearGradient(
        colors: [widget.style!.accentBackgroundColor, Colors.transparent],
        stops: const [0.5, 0.5],
      );
    }
    return BoxDecoration(
      color: currentDateRange!.between(date)
          ? widget.style?.accentBackgroundColor
          : null,
      gradient: gradient,
    );
  }

  BoxDecoration? getStartOrEndDateBoxDecoration(DateTime date) {
    if (currentDateRange == null) return null;
    if (isStartAndEndDateEqual(date)) {
      return null;
    }
    LinearGradient? gradient;
    if (date == currentDateRange!.start) {
      gradient = LinearGradient(
        colors: [widget.style!.accentBackgroundColor, Colors.transparent],
        stops: const [0.5, 0.5],
      );
    }
    if (date == currentDateRange!.end) {
      gradient = LinearGradient(
        colors: [Colors.transparent, widget.style!.accentBackgroundColor],
        stops: const [0.5, 0.5],
      );
    }
    return BoxDecoration(shape: BoxShape.circle, gradient: gradient);
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    if (isStartOrEndDate(date)) {
      return const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
    }
    return const TextStyle(fontWeight: FontWeight.w600);
  }

  Color? getDateForegroundColor(Set<MaterialState> states, DateTime date) {
    if (isStartOrEndDate(date) || date == DateUtils.dateOnly(DateTime.now())) {
      return widget.style?.accentColor;
    }
    if (date.month == initDate.month) {
      return widget.style?.primaryColor;
    }
    return widget.style?.secondaryColor;
  }

  Color? getDateBackground(Set<MaterialState> states, DateTime date) {
    if (date == startDate || isStartAndEndDateEqual(date)) {
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
            child: Container(
              width: 36,
              height: 32,
              decoration: getDateBoxDecoration(date),
              child: Stack(children: [
                Positioned.fill(
                  child: Container(
                    decoration: getStartOrEndDateBoxDecoration(date),
                  ),
                ),
                Positioned.fill(
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
                ))
              ]),
            ),
          ),
      ],
    );
  }
}
