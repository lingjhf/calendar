import 'package:flutter/widgets.dart';

class CalendarYearPicker extends StatefulWidget {
  const CalendarYearPicker({super.key});
  @override
  State<StatefulWidget> createState() => _CalendarYearPickerState();
}

class _CalendarYearPickerState extends State<CalendarYearPicker> {
  @override
  Widget build(BuildContext context) {
    return GridView(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4));
  }
}
