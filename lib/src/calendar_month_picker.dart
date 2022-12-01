import 'package:flutter/material.dart';

import 'base.dart';
import 'extensions.dart';

class CalendarMonthPicker extends BasePicker {
  CalendarMonthPicker({
    super.key,
    super.initDate,
    super.currentDate,
    super.style,
    super.onChange,
    this.onYearPick,
  });

  final VoidCallback? onYearPick;

  @override
  State<StatefulWidget> createState() => _CalendarMonthPickerState();
}

class _CalendarMonthPickerState extends State<CalendarMonthPicker> {
  late DateTime initDate;

  late DateTime currentDate;

  List<DateTime> dates = [];

  ButtonStyle titleButtonStyle = const ButtonStyle();

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
    titleButtonStyle = titleButtonStyle.merge(style);
    actionButtonStyle = actionButtonStyle.merge(style);

    initDate = widget.initDate;
    currentDate = widget.currentDate;
    setDates(initDate);
    super.initState();
  }

  void setDates(DateTime date) {
    var dates = <DateTime>[];
    for (int i = 1; i <= 12; i++) {
      dates.add(DateTime(initDate.year, i));
    }
    for (int i = 1; i <= 4; i++) {
      dates.add(DateTime(initDate.year + 1, i));
    }
    this.dates = dates;
  }

  void onPrevYear() {
    setState(() {
      initDate = initDate.subtractYear();
      setDates(initDate);
    });
  }

  void onNextYear() {
    setState(() {
      initDate = initDate.addYear();
      setDates(initDate);
    });
  }

  void onSelectMonth(DateTime date) {
    initDate = DateTime(date.year, date.month, currentDate.day);
    widget.onChange?.call(initDate);
  }

  Widget buildToolbar() {
    return Row(
      children: [
        TextButton(
          style: actionButtonStyle,
          onPressed: onPrevYear,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const Spacer(),
        TextButton(
          style: titleButtonStyle,
          onPressed: () => widget.onYearPick?.call(),
          child: Text('${initDate.year}'),
        ),
        const Spacer(),
        TextButton(
          style: actionButtonStyle,
          onPressed: onNextYear,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
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

                if ((date.year == currentDate.year &&
                        date.month == currentDate.month) ||
                    (date.year == now.year && date.month == now.month)) {
                  return widget.style?.accentColor;
                }
                if (date.year == initDate.year) {
                  return widget.style?.primaryColor;
                }
                return widget.style?.secondaryColor;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (date.year == currentDate.year &&
                    date.month == currentDate.month) {
                  return widget.style?.accentBackgroundColor;
                }
                return null;
              }),
              overlayColor: MaterialStateProperty.resolveWith((states) {
                return widget.style?.accentBackgroundColor;
              }),
            ),
            onPressed: () => onSelectMonth(date),
            child: Text('${date.month}'),
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
