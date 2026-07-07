import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../app/di.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/other_widgets/common_loader.dart';
import '../../../../core/component/other_widgets/no_data.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/models/notification_model.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _scrollController = ScrollController();
  late final NotificationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = NotificationsBloc(sl<NotificationRemoteDataSource>())
      ..add(NotificationsStarted());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _bloc.add(NotificationsLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: CommonText(
            text: AppString.notifications,
            fontWeight: FontWeight.w600,
            fontSize: 24.sp,
          ),
        ),
        body: BlocConsumer<NotificationsBloc, NotificationsState>(
          listenWhen: (prev, curr) => curr.error != null,
          listener: (context, state) =>
              AppSnackbar.error(message: state.error ?? ''),
          builder: (context, state) {
            if (state.isLoading) {
              return const CommonLoader();
            }

            if (state.notifications.isEmpty) {
              return const NoData();
            }

            return RefreshIndicator(
              onRefresh: () async => _bloc.add(NotificationsRefreshed()),
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: state.isLoadingMore
                    ? state.notifications.length + 1
                    : state.notifications.length,
                itemBuilder: (_, index) {
                  if (index >= state.notifications.length) {
                    return const Padding(
                      padding: .all(12),
                      child: CommonLoader(size: 30, strokeWidth: 2),
                    );
                  }
                  final NotificationModel item = state.notifications[index];
                  return NotificationItem(item: item);
                },
              ),
            );
          },
        ),
        bottomNavigationBar: const CommonBottomNavBar(currentIndex: 1),
      ),
    );
  }
}
