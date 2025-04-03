import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

// Событие смены группы
class ChangeGroupEvent extends ScheduleEvent {
  final String newGroup;

  const ChangeGroupEvent(this.newGroup);

  @override
  List<Object> get props => [newGroup];
}

// Событие выбора дня
class SelectDayEvent extends ScheduleEvent {
  final DateTime selectedDay;

  const SelectDayEvent(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}

// Событие для выбора кнопки навигации
class SelectBottomNavEvent extends ScheduleEvent {
  final int index;
  SelectBottomNavEvent(this.index);

  @override
  List<Object?> get props => [index];
}