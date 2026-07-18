import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/storage_services.dart';
import '../../../../core/utils/helpers/other_helper.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this._updateProfile}) : super(const ProfileState()) {
    on<ProfileLanguageSelected>(_onLanguageSelected);
    on<ProfileImagePicked>(_onImagePicked);
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

  final UpdateProfile _updateProfile;

  void _onLanguageSelected(
    ProfileLanguageSelected event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(selectedLanguage: state.languages[event.index]));
  }

  Future<void> _onImagePicked(
    ProfileImagePicked event,
    Emitter<ProfileState> emit,
  ) async {
    final image = await OtherHelper.pickImage();
    if (image != null) emit(state.copyWith(image: image));
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (LocalStorage.token.isEmpty) return;

    emit(state.copyWith(status: ApiStatus.loading));

    final result = await _updateProfile(
      fullName: event.fullName,
      phone: event.phone,
      imagePath: state.image,
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            status: ApiStatus.success,
            message: 'Profile updated successfully',
          ),
        );
      case Failed(:final failure):
        emit(
          state.copyWith(status: ApiStatus.failure, message: failure.message),
        );
    }
  }
}
