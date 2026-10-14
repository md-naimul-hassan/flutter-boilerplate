import 'package:flutter_boilerplate/app/di.dart';
import 'package:flutter_boilerplate/features/auth/change_password/presentation/bloc/change_password_bloc.dart';
import 'package:flutter_boilerplate/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:flutter_boilerplate/features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'package:flutter_boilerplate/features/auth/sign_up/presentation/bloc/sign_up_bloc.dart';
import 'package:flutter_boilerplate/features/message/presentation/bloc/chat_bloc.dart';
import 'package:flutter_boilerplate/features/message/presentation/bloc/message_bloc.dart';
import 'package:flutter_boilerplate/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:flutter_boilerplate/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_boilerplate/features/setting/presentation/bloc/privacy_policy_bloc.dart';
import 'package:flutter_boilerplate/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:flutter_boilerplate/features/setting/presentation/bloc/terms_of_services_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(dependencyInjection);

  test('every bloc can be resolved', () {
    expect(sl<SignInBloc>(), isA<SignInBloc>());
    expect(sl<SignUpBloc>(), isA<SignUpBloc>());
    expect(sl<ForgotPasswordBloc>(), isA<ForgotPasswordBloc>());
    expect(sl<ChangePasswordBloc>(), isA<ChangePasswordBloc>());
    expect(sl<ChatBloc>(), isA<ChatBloc>());
    expect(sl<MessageBloc>(), isA<MessageBloc>());
    expect(sl<NotificationsBloc>(), isA<NotificationsBloc>());
    expect(sl<ProfileBloc>(), isA<ProfileBloc>());
    expect(sl<SettingBloc>(), isA<SettingBloc>());
    expect(sl<PrivacyPolicyBloc>(), isA<PrivacyPolicyBloc>());
    expect(sl<TermsOfServicesBloc>(), isA<TermsOfServicesBloc>());
  });

  test('flow blocs are shared across screens', () {
    expect(identical(sl<SignUpBloc>(), sl<SignUpBloc>()), isTrue);
    expect(
      identical(sl<ForgotPasswordBloc>(), sl<ForgotPasswordBloc>()),
      isTrue,
    );
  });

  test('screen blocs are created per screen', () {
    expect(identical(sl<SignInBloc>(), sl<SignInBloc>()), isFalse);
  });
}
