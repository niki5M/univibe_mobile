import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/cards.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        // Здесь будет реальный API вместо мокапчиков
        await Future.delayed(const Duration(seconds: 1));
        emit(HomeLoaded(classes: mockClasses, applications: mockApplications));
      } catch (e) {
        emit(HomeError('Не удалось загрузить данные'));
      }
    });
  }
}