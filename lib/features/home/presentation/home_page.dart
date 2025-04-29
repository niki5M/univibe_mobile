import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:uni_mobile/features/schedule/presentation/schedule_page.dart';
import '../../../core/layout/main_layout.dart';
import '../data/cards.dart';
import '../data/news.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final upcomingClasses = _getClassesForDate(_selectedDate);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDayCalendarCard(context, upcomingClasses),
            const SizedBox(height: 16),
            _buildNewsList(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Новости',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (mockNews.isEmpty)
          const Center(child: Text('Новости не найдены'))
        else
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: mockNews.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final news = mockNews[index];
                return SizedBox(
                  width: 300,
                  child: ShadCard(
                    radius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              news.imageUrl,
                              height: 150,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 150,
                                width: 100,
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    news.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const Spacer(),
                                  Text(
                                    news.date,
                                    style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }


  Widget _buildDayCalendarCard(BuildContext context, List<ClassInfo> classes) {
    final formattedDate = DateFormat('EEEE, dd MMMM', 'ru_RU').format(_selectedDate);

    return ShadCard(
      radius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.calendar_today),
                //   onPressed: () => _navigateToSchedulePage(context),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            EasyDateTimeLine(
              initialDate: _selectedDate,
              onDateChange: (selectedDate) {
                setState(() {
                  _selectedDate = selectedDate;
                });
              },
              headerProps: const EasyHeaderProps(
                showHeader: false,
              ),
              dayProps: const EasyDayProps(
                height: 50,
                width: 50,
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    color: Color(0xFF6D58D0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (classes.isEmpty)
              Center(
                child: Text(
                  'Нет пар на выбранный день',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              )
            else
              ...classes.map((classInfo) => [
                _buildClassItem(context, classInfo),
                if (classInfo != classes.last) const Divider(height: 16),
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

  Widget _buildClassItem(BuildContext context, ClassInfo info) {
    IconData icon;
    Color color;

    switch (info.type.toLowerCase()) {
      case 'лекция':
        icon = Icons.school;
        color = Color(0xff87A9FF);
        break;
      case 'практика':
        icon = LucideIcons.settings;
        color = Color(0xff31C2BB);
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return InkWell(
      onTap: () => _showClassDetails(context, info),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, color: color, size: 20 ),
              const SizedBox(height: 10),
              Container(
                width: 4,
                height: 45,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
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
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, color: Colors.grey[600]),
                    Text(
                      '${info.room} • ${info.teacher}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  List<ClassInfo> _getClassesForDate(DateTime date) {
    final selectedDayName = DateFormat('EEEE', 'ru_RU').format(date).toLowerCase();

    return mockClasses.where((classInfo) {
      final mockDayName = classInfo.date.split(',').first.trim().toLowerCase();
      return mockDayName == selectedDayName;
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