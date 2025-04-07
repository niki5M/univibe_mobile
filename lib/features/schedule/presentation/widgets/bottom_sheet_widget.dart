import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/schedule_data.dart';

class ScheduleModalSheet extends StatelessWidget {
  final String groupName;

  const ScheduleModalSheet({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final iconColor = Theme.of(context).iconTheme.color;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Расписание для группы $groupName",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildScheduleList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context) {
    final scrollController = ScrollController();

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(top: 8),
        itemCount: scheduleData.length,
        itemBuilder: (context, index) {
          final item = scheduleData[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: item.isImportant ? Colors.blueAccent : _getBorderColor(index),
                width: 1.7,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.type,
                        style: TextStyle(
                          fontSize: 13,
                          color: _getTypeColor(item.type),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.teacher,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        item.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBorderColor(int index) {
    switch (index % 3) {
      case 0:
        return Colors.lightBlue;
      case 1:
        return Colors.lightBlue;
      case 2:
        return Colors.amber;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getTypeColor(String type) {
    if (type.toLowerCase().contains("лекция")) {
      return Colors.blueAccent;
    } else if (type.toLowerCase().contains("практика")) {
      return Colors.orangeAccent;
    }
    return Colors.grey;
  }
}
