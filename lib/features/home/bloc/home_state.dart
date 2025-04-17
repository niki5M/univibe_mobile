import '../data/cards.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ClassInfo> classes;
  final List<ApplicationStatus> applications;

  HomeLoaded({required this.classes, required this.applications});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}