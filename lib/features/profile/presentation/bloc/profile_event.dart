part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLanguageSelected extends ProfileEvent {
  const ProfileLanguageSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class ProfileImagePicked extends ProfileEvent {
  const ProfileImagePicked();
}

class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested({required this.fullName, required this.phone});

  final String fullName;
  final String phone;

  @override
  List<Object?> get props => [fullName, phone];
}
