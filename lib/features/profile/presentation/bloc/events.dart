sealed class ProfileEvent {}

class ProfileLanguageSelected extends ProfileEvent {
  final int index;
  ProfileLanguageSelected(this.index);
}

class ProfileImagePicked extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final String fullName;
  final String phone;

  ProfileUpdateRequested({required this.fullName, required this.phone});
}
