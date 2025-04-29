class ClassInfo {
  final String date;
  final String timeStart;
  final String timeEnd;
  final String name;
  final String room;
  final String teacher;
  final String type;

  ClassInfo({
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.name,
    required this.room,
    required this.teacher,
    required this.type,
  });
}

class ApplicationStatus {
  final String title;
  final String status;
  final String date;
  final String? note;
  final StatusType type;

  ApplicationStatus({
    required this.title,
    required this.status,
    required this.date,
    this.note,
    required this.type,
  });
}

enum StatusType { ready, inProgress, rejected }

final List<ClassInfo> mockClasses = [
  ClassInfo(
    date: 'понедельник',
    timeStart: '9:40',
    timeEnd: '11:10',
    name: 'Теория алгоритмов',
    room: 'Ауд. 236',
    teacher: 'Преп. Абдураманов З.Ш.',
    type: 'Лекция',
  ),
  ClassInfo(
    date: 'понедельник',
    timeStart: '11:30',
    timeEnd: '13:00',
    name: 'Математическая логика',
    room: 'Ауд. 233',
    teacher: 'Преп. Абдураманов З.Ш.',
    type: 'Практика',
  ),
  ClassInfo(
    date: 'вторник',
    timeStart: '09:40',
    timeEnd: '11:10',
    name: 'Проектный практикум',
    room: 'Ауд. 233',
    teacher: 'Преп. Аметов О.М.',
    type: 'Лекция',
  ),
  ClassInfo(
    date: 'среда',
    timeStart: '9:40',
    timeEnd: '11:10',
    name: 'Теория алгоритмов',
    room: 'Ауд. 236',
    teacher: 'Преп. Абдураманов З.Ш.',
    type: 'Лекция',
  ),
  ClassInfo(
    date: 'среда',
    timeStart: '11:30',
    timeEnd: '13:00',
    name: 'Математическая логика',
    room: 'Ауд. 233',
    teacher: 'Преп. Абдураманов З.Ш.',
    type: 'Практика',
  ),
  ClassInfo(
    date: 'четверг',
    timeStart: '11:30',
    timeEnd: '13:00',
    name: 'Математическая логика',
    room: 'Ауд. 233',
    teacher: 'Преп. Абдураманов З.Ш.',
    type: 'Практика',
  ),
  ClassInfo(
    date: 'пятница',
    timeStart: '09:40',
    timeEnd: '11:10',
    name: 'Проектный практикум',
    room: 'Ауд. 233',
    teacher: 'Преп. Аметов О.М.',
    type: 'Лекция',
  ),
];

List<ApplicationStatus> mockApplications = [
  ApplicationStatus(
    title: 'Справка об обучении',
    status: 'Готова',
    date: 'Запрошена: 12.04.2025',
    type: StatusType.ready,
  ),
  ApplicationStatus(
    title: 'Справка в военкомат',
    status: 'В обработке',
    date: 'Запрошена: 10.04.2025',
    type: StatusType.inProgress,
  ),
  ApplicationStatus(
    title: 'Справка о стипендии',
    status: 'Отклонена',
    date: 'Запрошена: 05.04.2025',
    note: 'Необходимо уточнить данные',
    type: StatusType.rejected,
  ),
];