/// Events
sealed class ChangePasswordEvent {}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordSubmitted({
    required this.oldPassword,
    required this.newPassword,
  });
}