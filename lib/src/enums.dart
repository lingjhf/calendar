enum CalendarMode {
  day,
  month,
  year,
}

enum CalendarWeekDay {
  monday(value: DateTime.monday, name: 'monday'),
  tuesday(value: DateTime.tuesday, name: 'tuesday'),
  wednesday(value: DateTime.wednesday, name: 'wednesday'),
  thursday(value: DateTime.thursday, name: 'thursday'),
  friday(value: DateTime.friday, name: 'friday'),
  saturday(value: DateTime.saturday, name: 'saturday'),
  sunday(value: DateTime.sunday, name: 'sunday');

  const CalendarWeekDay({required this.value, required this.name});

  final int value;

  final String name;
}
