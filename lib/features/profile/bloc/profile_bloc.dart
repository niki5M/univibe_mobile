import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_mobile/features/profile/bloc/profile_event.dart';
import 'package:uni_mobile/features/profile/bloc/profile_state.dart';

class Profile {
  final String name;
  final String email;
  final String group;

  Profile({required this.name, required this.email, required this.group});

  Profile copyWith({
    String? name,
    String? email,
    String? group,
  }) {
    return Profile(
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
              group == other.group;

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ group.hashCode;
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  static ProfileBloc of(BuildContext context) => BlocProvider.of<ProfileBloc>(context);

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(ProfileLoaded(
          Profile(
              name: 'Сейдаметов С.',
              email: 'email@example.com',
              group: 'Группа A'  // Пример значения для поля group
          )
      ));
    } catch (e) {
      emit(ProfileError('Не удалось загрузить профиль'));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      emit(ProfileLoaded(event.profile));
    }
  }
}