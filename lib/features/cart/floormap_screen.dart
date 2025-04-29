import 'package:flutter/material.dart';

class Classroom {
  final String number;
  final String type;
  final int capacity;
  final String description;

  Classroom({
    required this.number,
    required this.type,
    required this.capacity,
    required this.description,
  });
}

class FloorMapScreen extends StatefulWidget {
  const FloorMapScreen({super.key});

  @override
  State<FloorMapScreen> createState() => _FloorMapScreenState();
}

class _FloorMapScreenState extends State<FloorMapScreen> {
  final Map<String, Classroom> classrooms = {
    '134': Classroom(
      number: '134',
      type: 'Учебная аудитория',
      capacity: 25,
      description: 'Основная лекционная аудитория с проектором',
    ),
    'X': Classroom(
      number: 'X',
      type: 'Лаборатория',
      capacity: 15,
      description: 'Компьютерная лаборатория',
    ),
    'O': Classroom(
      number: 'O',
      type: 'Семинарская',
      capacity: 20,
      description: 'Аудитория для семинарских занятий',
    ),
    // Добавьте остальные аудитории по аналогии
  };

  void _showClassroomInfo(BuildContext context, String roomNumber) {
    final classroom = classrooms[roomNumber] ?? Classroom(
      number: roomNumber,
      type: 'Неизвестный тип',
      capacity: 0,
      description: 'Информация об этой аудитории отсутствует',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Аудитория ${classroom.number}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тип: ${classroom.type}'),
            Text('Вместимость: ${classroom.capacity} чел.'),
            const SizedBox(height: 10),
            Text(classroom.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта этажа'),
        centerTitle: true,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 3.0,
        boundaryMargin: const EdgeInsets.all(100),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Информация о текущей аудитории
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Аудитория 134',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Учебная аудитория'),
                    const SizedBox(height: 5),
                    const Text('Вместимость: 25 чел.'),
                    const SizedBox(height: 10),
                    Text(
                      'Нажмите на аудиторию для выбора',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Первый ряд аудиторий
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ClassroomButton(
                    number: 'X',
                    onPressed: () => _showClassroomInfo(context, 'X'),
                  ),
                  _ClassroomButton(
                    number: 'O',
                    onPressed: () => _showClassroomInfo(context, 'O'),
                  ),
                  _ClassroomButton(
                    number: '124',
                    onPressed: () => _showClassroomInfo(context, '124'),
                  ),
                  _ClassroomButton(
                    number: 'M',
                    onPressed: () => _showClassroomInfo(context, 'M'),
                  ),
                  _ClassroomButton(
                    number: 'DB',
                    onPressed: () => _showClassroomInfo(context, 'DB'),
                  ),
                  _ClassroomButton(
                    number: 'USA',
                    onPressed: () => _showClassroomInfo(context, 'USA'),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Второй ряд аудиторий
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ClassroomButton(
                    number: 'HB',
                    onPressed: () => _showClassroomInfo(context, 'HB'),
                  ),
                  _ClassroomButton(
                    number: 'IDA',
                    onPressed: () => _showClassroomInfo(context, 'IDA'),
                  ),
                  _ClassroomButton(
                    number: 'C',
                    onPressed: () => _showClassroomInfo(context, 'C'),
                  ),
                  _ClassroomButton(
                    number: 'HBA',
                    onPressed: () => _showClassroomInfo(context, 'HBA'),
                  ),
                  _ClassroomButton(
                    number: '231',
                    onPressed: () => _showClassroomInfo(context, '231'),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Третий ряд аудиторий
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ClassroomButton(
                    number: '191',
                    onPressed: () => _showClassroomInfo(context, '191'),
                  ),
                  const SizedBox(width: 50),
                  const SizedBox(width: 50),
                  _ClassroomButton(
                    number: '193',
                    onPressed: () => _showClassroomInfo(context, '193'),
                  ),
                  _ClassroomButton(
                    number: '195',
                    onPressed: () => _showClassroomInfo(context, '195'),
                  ),
                  _ClassroomButton(
                    number: '197',
                    onPressed: () => _showClassroomInfo(context, '197'),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Четвертый ряд аудиторий
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 50),
                  _ClassroomButton(
                    number: '199',
                    onPressed: () => _showClassroomInfo(context, '199'),
                  ),
                  _ClassroomButton(
                    number: '198',
                    onPressed: () => _showClassroomInfo(context, '198'),
                  ),
                  const SizedBox(width: 50),
                  const SizedBox(width: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassroomButton extends StatelessWidget {
  final String number;
  final VoidCallback onPressed;

  const _ClassroomButton({
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}