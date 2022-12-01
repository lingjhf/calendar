extension DateExtension on DateTime {
  String monthString() {
    switch (month) {
      case DateTime.january:
        return 'January';
      case DateTime.february:
        return 'February';
      case DateTime.march:
        return 'March';
      case DateTime.april:
        return 'April';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'June';
      case DateTime.july:
        return 'July';
      case DateTime.august:
        return 'August';
      case DateTime.september:
        return 'September';
      case DateTime.october:
        return 'October';
      case DateTime.november:
        return 'November';
      default:
        return 'December';
    }
  }

  DateTime addYear() {
    return DateTime(year + 1, month, day);
  }

  DateTime subtractYear() {
    return DateTime(year - 1, month, day);
  }

  DateTime addMonth() {
    var y = year;
    var m = month + 1;
    if (m > 12) {
      y += 1;
      m = 1;
    }
    return DateTime(y, m, day);
  }

  //上一个月
  DateTime subtractMonth() {
    var y = year;
    var m = month - 1;
    if (m < 1) {
      y -= 1;
      m = 12;
    }
    return DateTime(y, m, day);
  }
}
