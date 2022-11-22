import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  Calendar({
    super.key,
    required DateTime firstDate,
    required DateTime lastDate,
  })  : firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate);

  final DateTime firstDate;

  final DateTime lastDate;

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        
      ],),
    );
  }
}
