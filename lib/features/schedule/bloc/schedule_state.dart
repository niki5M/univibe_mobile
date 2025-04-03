import 'package:equatable/equatable.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

// Начальное состояние
class ScheduleInitial extends ScheduleState {}

// Состояние выбранного дня
class DaySelectedState extends ScheduleState {
  final DateTime selectedDay;

  const DaySelectedState(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}

// Состояние выбранной группы
class GroupSelectedState extends ScheduleState {
  final String selectedGroup;

  const GroupSelectedState(this.selectedGroup);

  @override
  List<Object?> get props => [selectedGroup];
}

class BottomNavSelectedState extends ScheduleState {
  final int selectedIndex;
  const BottomNavSelectedState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

