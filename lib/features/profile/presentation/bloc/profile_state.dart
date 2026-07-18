part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.languages = const ['English', 'French', 'Arabic'],
    this.selectedLanguage = 'English',
    this.image,
    this.status = ApiStatus.initial,
    this.message = '',
  });

  final List<String> languages;
  final String selectedLanguage;
  final String? image;
  final ApiStatus status;
  final String message;

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

  @override
  List<Object?> get props => [
    languages,
    selectedLanguage,
    image,
    status,
    message,
  ];
}
