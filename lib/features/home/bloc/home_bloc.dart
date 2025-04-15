import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/home_page.dart';
import 'home_event.dart';
import 'home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // Handle events here
    });
  }
}