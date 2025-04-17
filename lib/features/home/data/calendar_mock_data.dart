import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'cards.dart';

List<CalendarEventData<ClassInfo>> getEventsForDate(DateTime date) {
  if (date.day == 14 && date.month == 4) {
    return mockClasses.map((classInfo) {
      final startParts = classInfo.timeStart.split(':').map(int.parse).toList();
      final endParts = classInfo.timeEnd.split(':').map(int.parse).toList();

      final startTime = DateTime(date.year, date.month, date.day, startParts[0], startParts[1]);
      final endTime = DateTime(date.year, date.month, date.day, endParts[0], endParts[1]);

      return CalendarEventData<ClassInfo>(
        date: date,
        startTime: startTime,
        endTime: endTime,
        title: classInfo.name,
        event: classInfo,
      );
    }).toList();
  } else {
    return [];
  }
}