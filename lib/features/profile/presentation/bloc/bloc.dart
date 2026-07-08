import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/storage/storage_services.dart';
import '../../../../core/utils/helpers/other_helper.dart';
import '../../data/datasources/remote_data_source.dart';
import 'events.dart';
import 'state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteDataSource _remote;

  ProfileBloc(this._remote) : super(const ProfileState()) {
    on<ProfileLanguageSelected>(_onLanguageSelected);
    on<ProfileImagePicked>(_onImagePicked);
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

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

    try {
      await _remote.updateProfile(
        fullName: event.fullName,
        phone: event.phone,
        imagePath: state.image,
      );

      emit(
        state.copyWith(
          status: ApiStatus.success,
          message: 'Profile updated successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, message: e.toString()));
    }
  }
}
