import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_mobile/features/schedule/presentation/schedule_page.dart';
import '../../../core/layout/main_layout.dart';
import '../data/cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final EventController eventController;
  bool _showCalendar = false; // Добавляем состояние для переключения вида

  @override
  void initState() {
    super.initState();
    eventController = EventController()..addAll(_generateEventsFromClasses());
  }

  @override
  void dispose() {
    eventController.dispose();
    super.dispose();
  }

  Color _statusColor(StatusType type) {
    switch (type) {
      case StatusType.ready:
        return Colors.green;
      case StatusType.inProgress:
        return Colors.orange;
      case StatusType.rejected:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcomingClasses = mockClasses.take(3).toList();

    return CalendarControllerProvider(
      controller: eventController,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Условный рендеринг в зависимости от состояния _showCalendar
              if (!_showCalendar)
                _buildNearestClassesCard(context, upcomingClasses),
              if (_showCalendar)
                _buildDayCalendarCard(context),

              const SizedBox(height: 16),
              _buildApplicationStatusCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearestClassesCard(BuildContext context, List<ClassInfo> classes) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    setState(() {
                      _showCalendar = true; // Переключаем на календарь
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (classes.isEmpty)
              Center(
                child: Text(
                  'Нет пар на сегодня',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              )
            else
              ...classes.map((classInfo) => [
                _buildClassItem(context, classInfo),
                if (classInfo != classes.last) const Divider(height: 24),
              ]).expand((i) => i),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _navigateToSchedulePage(context),
                child: const Text('Показать полное расписание'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCalendarCard(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM', 'ru_RU').format(today);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
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
                  '$formattedDate',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    setState(() {
                      _showCalendar = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 500,
              child: DayView(
                controller: eventController,
                showVerticalLine: true,
                showLiveTimeLineInAllDays: true,
                startHour: 8,
                endHour: 20,
                eventTileBuilder: (date, events, boundry, start, end) {
                  final event = events.first;
                  final classInfo = event.event as ClassInfo;

                  return GestureDetector(
                    onTap: () => _showClassDetails(context, classInfo),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary
                              .withOpacity(0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        event.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  );
                },
                hourIndicatorSettings: HourIndicatorSettings(
                  color: Theme.of(context).dividerColor,
                  height: 1,
                  offset: 5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _navigateToSchedulePage(context),
                child: const Text('Показать полное расписание'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Остальные методы остаются без изменений
  Widget _buildClassItem(BuildContext context, ClassInfo info) {
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
                '${info.type} / ${info.timeStart}-${info.timeEnd}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                info.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${info.room} • ${info.teacher}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationStatusCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            ...mockApplications.map((app) => [
              _buildApplicationStatusItem(context, app),
              if (app != mockApplications.last) const Divider(height: 24),
            ]).expand((i) => i),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {}, // TODO: Implement all applications view
                child: const Text('Все заявки'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatusItem(BuildContext context, ApplicationStatus item) {
    final color = _statusColor(item.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          item.date,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        if (item.note != null) ...[
          const SizedBox(height: 4),
          Text(
            item.note!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  void _showClassDetails(BuildContext context, ClassInfo classInfo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classInfo.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Тип:', classInfo.type),
              _buildDetailRow('Время:', '${classInfo.timeStart}-${classInfo.timeEnd}'),
              _buildDetailRow('Аудитория:', classInfo.room),
              _buildDetailRow('Преподаватель:', classInfo.teacher),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Закрыть'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  List<CalendarEventData> _generateEventsFromClasses() {
    final now = DateTime.now();
    return mockClasses.map((classInfo) {
      final startParts = classInfo.timeStart.split(':').map(int.parse).toList();
      final endParts = classInfo.timeEnd.split(':').map(int.parse).toList();

      final startTime = DateTime(
        now.year, now.month, now.day,
        startParts[0], startParts[1],
      );
      final endTime = DateTime(
        now.year, now.month, now.day,
        endParts[0], endParts[1],
      );

      return CalendarEventData(
        date: now,
        startTime: startTime,
        endTime: endTime,
        title: classInfo.name,
        event: classInfo,
      );
    }).toList();
  }

  void _navigateToSchedulePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainLayout(child: const SchedulePage()),
      ),
    );
  }
}