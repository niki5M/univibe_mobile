import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_mobile/features/profile/bloc/profile_event.dart';
import 'package:uni_mobile/features/profile/bloc/profile_state.dart';

import '../../../core/auth/auth_repository.dart';
import '../../../core/auth/bloc/auth_bloc.dart';
import '../../../core/auth/bloc/auth_state.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String group;


  Profile({required this.name, required this.email, required this.group, required this.id});

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? group,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      group: group ?? this.group,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Profile &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              email == other.email &&
              group == other.group &&
              id == other.id
  ;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode ^ group.hashCode;
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  ProfileBloc({required this.authRepository, required this.authBloc})
      : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  static ProfileBloc of(BuildContext context) => BlocProvider.of<ProfileBloc>(context);

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());

      if (authBloc.state is! AuthAuthenticated) {
        emit(ProfileError('Пользователь не аутентифицирован'));
        return;
      }

      final accessToken = (authBloc.state as AuthAuthenticated).accessToken;
      final userProfile = await authRepository.fetchUserProfile(accessToken);

      if (userProfile == null) {
        emit(ProfileError('Не удалось загрузить профиль'));
        return;
      }

      final profile = Profile(
        id: userProfile['sub'] ?? 'ID',
        name: userProfile['name'] ??
            userProfile['preferred_username'] ??
            'Пользователь',
        email: userProfile['email'] ?? 'email@example.com',
        group: userProfile['group'] ?? 'Группа не указана',
      );

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Ошибка загрузки профиля: $e'));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      emit(ProfileLoaded(event.profile));
    }
  }
}