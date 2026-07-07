import '../../../../app/enum.dart';

class ProfileState {
  final List<String> languages;
  final String selectedLanguage;
  final String? image;
  final ApiStatus status;
  final String message;

  const ProfileState({
    this.languages = const ['English', 'French', 'Arabic'],
    this.selectedLanguage = 'English',
    this.image,
    this.status = ApiStatus.initial,
    this.message = '',
  });

  ProfileState copyWith({
    String? selectedLanguage,
    String? image,
    ApiStatus? status,
    String? message,
  }) {
    return ProfileState(
      languages: languages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      image: image ?? this.image,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
