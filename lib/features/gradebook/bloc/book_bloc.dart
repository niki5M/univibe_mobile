import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/book_model.dart';
import 'book_event.dart';
import 'book_state.dart';

class GradeBloc extends Bloc<GradeEvent, GradeState> {
  GradeBloc() : super(GradesLoading()) {
    on<LoadGrades>(_onLoadGrades);
  }

  Future<void> _onLoadGrades(
      LoadGrades event, Emitter<GradeState> emit) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final mockData = [
        {
          "subject": "Проектный практикум",
          "teacher": "Аметов Осман Мидатович",
          "exam_type": "Экзамен",
          "grade": 5,
          "semester": 1,
        },
        {
          "subject": "ООП",
          "teacher": "Сейдаметов Гирей Серверович",
          "exam_type": "Зачёт",
          "grade": 4,
          "semester": 1,
        },
        {
          "subject": "Математическая логика",
          "teacher": "Абдураманов Зиннур Шевкетович",
          "exam_type": "Экзамен",
          "grade": 3,
          "semester": 2,
        },
        {
          "subject": "Математическая логика",
          "teacher": "Абдураманов Зиннур Шевкетович",
          "exam_type": "Экзамен",
          "grade": 3,
          "semester": 1,
        },
        {
          "subject": "Системное программирование",
          "teacher": "Абдураманов Зиннур Шевкетович",
          "exam_type": "Экзамен",
          "grade": 2,
          "semester": 2,
        },
      ];

      final records =
      mockData.map((e) => GradeRecord.fromJson(e)).toList();
      emit(GradesLoaded(records));
    } catch (e) {
      emit(GradesError('Ошибка загрузки: $e'));
    }
  }
}