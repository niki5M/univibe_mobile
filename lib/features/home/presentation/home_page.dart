import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomeInitial extends HomeState {}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildWelcomeHeader(),
              // const SizedBox(height: 24),
              _buildNearestClassesCard(),
              const SizedBox(height: 16),
              _buildApplicationStatusCard(),
              const SizedBox(height: 16),
              // Add more cards here if needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Добро пожаловать,',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Иван Иванов', // Replace with actual user name
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNearestClassesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ближайшие пары',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    // Navigate to schedule
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildClassItem(
              time: '09:00 - 10:30',
              name: 'Математический анализ',
              room: 'Аудитория 304',
              teacher: 'Проф. Петров',
            ),
            const Divider(height: 24),
            _buildClassItem(
              time: '10:45 - 12:15',
              name: 'Программирование',
              room: 'Аудитория 412',
              teacher: 'Доц. Сидорова',
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Show full schedule
              },
              child: const Text('Показать полное расписание'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem({
    required String time,
    required String name,
    required String room,
    required String teacher,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$room • $teacher',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Состояние заявок на справки',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildApplicationStatusItem(
              title: 'Справка об обучении',
              status: 'Готова',
              statusColor: Colors.green,
              date: 'Запрошена: 12.10.2023',
            ),
            const Divider(height: 24),
            _buildApplicationStatusItem(
              title: 'Справка в военкомат',
              status: 'В обработке',
              statusColor: Colors.orange,
              date: 'Запрошена: 10.10.2023',
            ),
            const Divider(height: 24),
            _buildApplicationStatusItem(
              title: 'Справка о стипендии',
              status: 'Отклонена',
              statusColor: Colors.red,
              date: 'Запрошена: 05.10.2023',
              note: 'Необходимо уточнить данные',
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to applications
                },
                child: const Text('Все заявки'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatusItem({
    required String title,
    required String status,
    required Color statusColor,
    required String date,
    String? note,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: statusColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        if (note != null) ...[
          const SizedBox(height: 4),
          Text(
            note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}