import 'package:flutter/material.dart';

import '../calendar.dart';

abstract class BasePicker extends StatefulWidget {
  BasePicker({
    super.key,
    DateTime? initDate,
    DateTime? currentDate,
    this.style,
    this.onChange,
  })  : initDate = initDate ?? DateTime.now(),
        currentDate = currentDate ?? DateTime.now();

  //初始化日期
  final DateTime initDate;

  //当前选择日期
  //如果有当前日期就定位到当期日期，如果没有就定位到今天
  final DateTime currentDate;

  final CalendarStyle? style;

  final ValueChanged<DateTime>? onChange;
}
