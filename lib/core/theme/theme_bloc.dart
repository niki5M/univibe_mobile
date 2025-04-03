import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Определяем события для переключения темы
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class SetLightTheme extends ThemeEvent {}

class SetDarkTheme extends ThemeEvent {}

// Блок управления темой
class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(_lightTheme) {
    on<ToggleTheme>((event, emit) {
      emit(state == _lightTheme ? _darkTheme : _lightTheme);
    });

    on<SetLightTheme>((event, emit) => emit(_lightTheme));
    on<SetDarkTheme>((event, emit) => emit(_darkTheme));
  }

  // Тёмная тема
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black87,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  // Светлая тема
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );
}