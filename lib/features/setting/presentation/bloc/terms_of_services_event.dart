part of 'terms_of_services_bloc.dart';

sealed class TermsOfServicesEvent extends Equatable {
  const TermsOfServicesEvent();

  @override
  List<Object?> get props => [];
}

class TermsOfServicesRequested extends TermsOfServicesEvent {
  const TermsOfServicesRequested();
}
