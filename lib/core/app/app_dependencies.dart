import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_mobile/core/auth/auth_repository.dart';
import 'package:uni_mobile/core/auth/bloc/auth_bloc.dart';
import 'package:uni_mobile/core/theme/theme_bloc.dart';
import 'package:uni_mobile/features/documents/bloc/doc_bloc.dart';
import 'package:uni_mobile/features/home/bloc/home_bloc.dart';
import 'package:uni_mobile/features/profile/bloc/profile_bloc.dart';
import 'package:uni_mobile/features/profile/bloc/profile_event.dart';
import 'package:uni_mobile/features/schedule/bloc/schedule_bloc.dart';

import '../../features/gradebook/bloc/book_bloc.dart';

class AppDependencies {
  static List<BlocProvider> get providers => [
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
    ),
    BlocProvider<ScheduleBloc>(
      create: (context) => ScheduleBloc(),
    ),
    BlocProvider<GradeBloc>(
      create: (context) => GradeBloc(),
    ),
    BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
    ),
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
    ),
    BlocProvider<DocumentBloc>(
      create: (context) => DocumentBloc(),
    ),
    BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        authRepository: AuthRepository(),
        authBloc: context.read<AuthBloc>(),
      )..add(LoadProfile()),
    ),
  ];
}