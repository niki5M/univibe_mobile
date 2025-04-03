import 'package:flutter/material.dart';
import '../../data/models/schedule_data.dart';

class ScheduleBottomPanel extends StatelessWidget {
  final ScrollController scrollController;

  const ScheduleBottomPanel({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Расписание для группы И-1-22(а)",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // const Divider(height: 1, thickness: 1, color: Colors.grey),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 8),
              itemCount: scheduleData.length,
              itemBuilder: (context, index) {
                final item = scheduleData[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
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
          ),
        ],
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
    } else if (type.toLowerCase().contains("практик")) {
      return Colors.orangeAccent;
    }
    return Colors.grey;
  }
}