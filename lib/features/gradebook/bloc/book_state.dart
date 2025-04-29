

import '../data/models/book_model.dart';

abstract class GradeState {}

class GradesLoading extends GradeState {}

class GradesLoaded extends GradeState {
  final List<GradeRecord> records;

  GradesLoaded(this.records);
}

class GradesError extends GradeState {
  final String message;

  GradesError(this.message);
}