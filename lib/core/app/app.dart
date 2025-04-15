import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../theme/theme_bloc.dart';
import 'app_dependencies.dart';
import 'app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppDependencies.providers,
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return ShadApp(
            theme: ShadThemeData(
              brightness: Brightness.light,
              colorScheme: const ShadSlateColorScheme.light(),
            ),
            darkTheme: ShadThemeData(
              brightness: Brightness.dark,
              colorScheme: const ShadSlateColorScheme.dark(),
            ),
            themeMode: theme.brightness == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            routes: AppRouter.routes,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}