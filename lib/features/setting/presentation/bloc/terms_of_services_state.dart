part of 'terms_of_services_bloc.dart';

class TermsOfServicesState extends Equatable {
  const TermsOfServicesState({
    this.status = ApiStatus.initial,
    this.data = HtmlEntity.empty,
  });

  final ApiStatus status;
  final HtmlEntity data;

  TermsOfServicesState copyWith({ApiStatus? status, HtmlEntity? data}) {
    return TermsOfServicesState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
