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

abstract class BaseCalendarDatePicker extends StatefulWidget {
  const BaseCalendarDatePicker({
    super.key,
    this.readonly = false,
    required this.initDate,
    required this.dates,
    this.allowDates = const [],
    this.style,
    this.onInitDateChange,
  });

  final bool readonly;

  final DateTime initDate;

  final List<DateTime> dates;

  final List<DateTime> allowDates;

  final CalendarStyle? style;

  final ValueChanged<DateTime>? onInitDateChange;
}

abstract class BaseCalendarDatePickerState<T extends BaseCalendarDatePicker>
    extends State<T> {
  List<DateTime> dates = [];
  late DateTime initDate;

  late ButtonStyle cellStyle;

  @override
  void initState() {
    initDate = widget.initDate;
    dates = widget.dates;
    cellStyle = ButtonStyle(
      shape: const MaterialStatePropertyAll(CircleBorder()),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (widget.readonly) {
          return Colors.transparent;
        }
        return widget.style?.accentBackgroundColor;
      }),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    initDate = widget.initDate;
    dates = widget.dates;
    super.didUpdateWidget(oldWidget);
  }

  Color? getDateOverlayColor(Set<MaterialState> states, DateTime date) {
    if (widget.allowDates.isNotEmpty && !widget.allowDates.contains(date)) {
      return Colors.transparent;
    }
    return cellStyle.overlayColor?.resolve(states);
  }
}
