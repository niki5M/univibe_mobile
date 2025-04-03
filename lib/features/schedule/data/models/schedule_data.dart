class ScheduleItem {
  final String time;
  final String type;
  final String subject;
  final String teacher;
  final String location;
  final bool isImportant;

  ScheduleItem({
    required this.time,
    required this.type,
    required this.subject,
    required this.teacher,
    required this.location,
    this.isImportant = false,
  });
}

List<ScheduleItem> scheduleData = [
  ScheduleItem(
    time: '8:00 - 9:30',
    type: 'Лекция',
    subject: 'Проектный практикум',
    teacher: 'Абдураманнов Зиннур Шевкетович',
    location: '236 Аудитория',
    isImportant: true,
  ),
  ScheduleItem(
    time: '9:40 - 11:10',
    type: 'Практика',
    subject: 'Проектный практикум',
    teacher: 'Аметов Осман Мидатович',
    location: '233 Аудитория',
  ),
];