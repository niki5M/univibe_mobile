import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'core/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();

  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  await initializeDateFormatting('ru_RU', null);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global error: ${details.exceptionAsString()}');
  };
}