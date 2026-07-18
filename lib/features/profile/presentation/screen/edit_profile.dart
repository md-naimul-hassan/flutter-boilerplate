import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/enum.dart';
import '../../../../app/router.dart';
import '../../../../app/di.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/button/common_button.dart';
import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/storage/storage_services.dart';
import '../../../../app/constants/app_images.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/extension.dart';
import '../../data/datasources/remote_data_source.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';
import '../widgets/edit_profile_all_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ProfileState state) {
    if (state.status == ApiStatus.success) {
      AppSnackbar.success(title: 'Success', message: state.message);
      _nameController.clear();
      _numberController.clear();
      AppNavigator.push(AppRoutes.profile);
    } else if (state.status == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(sl<ProfileRemoteDataSource>()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const CommonText(
            text: AppString.profile,
            fontSize: 20,
            fontWeight: .w600,
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: _onStateChanged,
          builder: (context, state) {
            final userImage = LocalStorage.user.image;

            return SingleChildScrollView(
              padding: .symmetric(horizontal: 20.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      alignment: .bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 70.r,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: state.image != null
                                ? Image.file(
                                    File(state.image!),
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  )
                                : CommonImage(
                                    imageSrc: userImage.isEmpty
                                        ? AppImages.profile
                                        : userImage,
                                    width: 140,
                                    height: 140,
                                  ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<ProfileBloc>().add(
                            ProfileImagePicked(),
                          ),
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    24.height,
                    EditProfileAllFiled(
                      nameController: _nameController,
                      numberController: _numberController,
                    ),
                    30.height,
                    CommonButton(
                      titleText: AppString.saveAndChanges,
                      isLoading: state.status == ApiStatus.loading,
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        context.read<ProfileBloc>().add(
                          ProfileUpdateRequested(
                            fullName: _nameController.text,
                            phone: _numberController.text,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
