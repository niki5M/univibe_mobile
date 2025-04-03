import 'package:flutter_bloc/flutter_bloc.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<SelectDayEvent>((event, emit) {
      emit(DaySelectedState(event.selectedDay));
    });

    on<ChangeGroupEvent>((event, emit) {
      emit(GroupSelectedState(event.newGroup));
    });

    // Обработка события выбора кнопки навигации
    on<SelectBottomNavEvent>((event, emit) {
      emit(BottomNavSelectedState(event.index));
    });
  }
}