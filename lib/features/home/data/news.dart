// lib/features/home/data/news.dart

class News {
  final String title;
  final String description;
  final String date;
  final String imageUrl;

  News({
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
  });
}

final List<News> mockNews = [
  News(
    title: 'Открытие нового корпуса',
    description: 'На следующей неделе состоится открытие нового учебного корпуса на улице Академической.',
    date: '22 апреля 2025',
    imageUrl: 'assets/images/cat.jpeg',
  ),
  News(
    title: 'Весенний фестиваль',
    description: 'Приглашаем всех студентов на весенний фестиваль, который пройдет в эту пятницу.',
    date: '20 апреля 2025',
    imageUrl: 'assets/images/cat.jpeg',
  ),
  News(
    title: 'Обновление приложения',
    description: 'Мы выпустили новое обновление мобильного приложения с улучшениями производительности и новым дизайном.',
    date: '18 апреля 2025',
    imageUrl: 'assets/images/cat.jpeg',
  ),
  News(
    title: 'Конференция ИТ-факультета',
    description: 'Факультет информатики приглашает на ежегодную научную конференцию студентов и преподавателей.',
    date: '15 апреля 2025',
    imageUrl: 'assets/images/cat.jpeg',
  ),
  News(
    title: 'День открытых дверей',
    description: 'В эту субботу состоится День открытых дверей для абитуриентов и их родителей.',
    date: '13 апреля 2025',
    imageUrl: 'assets/images/hack.jpg',
  ),
];