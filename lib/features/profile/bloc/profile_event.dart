import 'package:equatable/equatable.dart';
import 'package:uni_mobile/features/profile/bloc/profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Profile profile;

  UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}