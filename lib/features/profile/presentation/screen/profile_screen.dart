import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router.dart';
import '../../../../app/di.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/other_widgets/item.dart';
import '../../../../core/component/pop_up/common_pop_menu.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/storeage/storage_services.dart';
import '../../../../core/utils/extension.dart';
import '../../data/datasources/remote_data_source.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(sl<ProfileRemoteDataSource>()),
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: AppString.profile,
            fontWeight: .w600,
            fontSize: 24,
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final user = LocalStorage.user;

            return Padding(
              padding: .symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [
                  16.height,
                  const CommonText(text: 'aslkfjskldfjkldsjlj'),

                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CommonImage(imageSrc: user.image, size: 140),
                    ),
                  ),
                  CommonText(text: user.name, fontSize: 18, fontWeight: .w700),
                  24.height,
                  Item(
                    icon: Icons.person,
                    title: AppString.editProfile,
                    onTap: () => AppNavigator.toNamed(AppRoutes.editProfile),
                  ),
                  Item(
                    icon: Icons.settings,
                    title: AppString.settings,
                    onTap: () => AppNavigator.toNamed(AppRoutes.setting),
                  ),
                  Padding(
                    padding: .symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language),
                            12.width,
                            CommonText(
                              text: state.selectedLanguage,
                              fontSize: 16,
                            ),
                            const Spacer(),
                            PopUpMenu(
                              items: state.languages,
                              selectedItem: [state.selectedLanguage],
                              onTap: (index) => context.read<ProfileBloc>().add(
                                ProfileLanguageSelected(index),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  const Item(
                    icon: Icons.logout,
                    title: AppString.logOut,
                    onTap: logOutPopUp,
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: const CommonBottomNavBar(currentIndex: 3),
      ),
    );
  }
}
