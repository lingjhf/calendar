import 'package:flutter/material.dart';

import 'base.dart';
import 'extensions.dart';

class CalendarYearPicker extends BasePicker {
  CalendarYearPicker({
    super.key,
    super.initDate,
    super.currentDate,
    super.style,
    super.onChange,
  });
  @override
  State<StatefulWidget> createState() => _CalendarYearPickerState();
}

class _CalendarYearPickerState extends State<CalendarYearPicker> {
  late DateTime initDate;

  late DateTime currentDate;

  List<DateTime> dates = [];

  late DateTimeRange yearRange;

  TextStyle titleStyle = const TextStyle();

  ButtonStyle actionButtonStyle = const ButtonStyle(
    shape: MaterialStatePropertyAll(CircleBorder()),
    padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
    minimumSize: MaterialStatePropertyAll(Size(0, 0)),
  );

  @override
  void initState() {
    final style = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(widget.style?.primaryColor),
      overlayColor:
          MaterialStatePropertyAll(widget.style?.accentBackgroundColor),
    );
    titleStyle = titleStyle.copyWith(
      color: widget.style?.primaryColor,
      fontWeight: FontWeight.w600,
    );
    actionButtonStyle = actionButtonStyle.merge(style);

    initDate = widget.initDate;
    currentDate = widget.currentDate;
    setDates(initDate);
    super.initState();
  }

  void setDates(DateTime date) {
    var dates = <DateTime>[];
    var n = date.year % 10;
    for (int i = 0; i <= 9 - n; i++) {
      dates.add(date.addYear(i));
    }
    for (int i = 1; i <= n; i++) {
      dates.insert(0, date.subtractYear(i));
    }
    final lastYear = dates.last;
    yearRange = DateTimeRange(start: dates.first, end: lastYear);
    for (int i = 1; i <= 6; i++) {
      dates.add(lastYear.addYear(i));
    }
    this.dates = dates;
  }

  void onPrev10Year() {
    setState(() {
      initDate = initDate.subtractYear(10);
      setDates(initDate);
    });
  }

  void onNext10Year() {
    setState(() {
      initDate = initDate.addYear(10);
      setDates(initDate);
    });
  }

  void onSelectYear(DateTime date) {
    initDate = DateTime(date.year, initDate.month, initDate.day);
    widget.onChange?.call(initDate);
  }

  Widget buildToolbar() {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          TextButton(
            style: actionButtonStyle,
            onPressed: onPrev10Year,
            child: const Icon(Icons.keyboard_arrow_left),
          ),
          const Spacer(),
          Text(
            '${yearRange.start.year} - ${yearRange.end.year}',
            style: titleStyle,
          ),
          const Spacer(),
          TextButton(
            style: actionButtonStyle,
            onPressed: onNext10Year,
            child: const Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }

  Widget buildDates() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 56,
      ),
      children: [
        for (var date in dates)
          TextButton(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.resolveWith((states) {
                return const TextStyle(fontWeight: FontWeight.w600);
              }),
              shape: const MaterialStatePropertyAll(CircleBorder()),
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                final now = DateTime.now();

                if (date.year == currentDate.year || date.year == now.year) {
                  return widget.style?.accentColor;
                }

                if (yearRange.start.year <= date.year &&
                    date.year <= yearRange.end.year) {
                  return widget.style?.primaryColor;
                }
                return widget.style?.secondaryColor;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (date.year == currentDate.year) {
                  return widget.style?.accentBackgroundColor;
                }
                return null;
              }),
              overlayColor: MaterialStateProperty.resolveWith((states) {
                return widget.style?.accentBackgroundColor;
              }),
            ),
            onPressed: () => onSelectYear(date),
            child: Text('${date.year}'),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [buildToolbar(), Expanded(child: buildDates())],
    );
  }
}
