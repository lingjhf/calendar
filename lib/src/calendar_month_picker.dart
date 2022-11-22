import 'package:flutter/material.dart';

class CalendarMonthPicker extends StatefulWidget {
  const CalendarMonthPicker({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarMonthPickerState();
}

class _CalendarMonthPickerState extends State<CalendarMonthPicker> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
    );
  }
}
