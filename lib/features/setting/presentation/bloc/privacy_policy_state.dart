part of 'privacy_policy_bloc.dart';

class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState({
    this.status = ApiStatus.initial,
    this.data = HtmlEntity.empty,
  });

  final ApiStatus status;
  final HtmlEntity data;

  PrivacyPolicyState copyWith({ApiStatus? status, HtmlEntity? data}) {
    return PrivacyPolicyState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
