import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_mobile/features/profile/presentation/user_profile.dart';
import 'package:uni_mobile/features/schedule/presentation/schedule_page.dart';
import 'package:uni_mobile/features/schedule/bloc/schedule_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

import 'core/auth/auth_repository.dart';
import 'core/auth/bloc/auth_bloc.dart';
import 'core/auth/presentation/login_page.dart';
import 'core/layout/main_layout.dart';
import 'core/theme/theme_bloc.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/profile/bloc/profile_event.dart';
import 'core/widgets/app_bar.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>(
          create: (context) => ScheduleBloc(),
          lazy: false,
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc()..add(LoadProfile()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'UniVibe',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: LoginPage(),
            routes: {
              '/profile': (context) => const EditProfilePage(),
              '/login': (context) => LoginPage(),
              '/schedule': (context) => MainLayout(child: const SchedulePage()),
            },
          );
        },
      ),
    );
  }
}