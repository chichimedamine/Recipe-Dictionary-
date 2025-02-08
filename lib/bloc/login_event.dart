part of 'login_bloc.dart';

@immutable
sealed class AuthEvent {}
class LoginStarted extends AuthEvent {
  BuildContext context;
  final String username;
  final String password;

  LoginStarted({ required this.context, required this.username, required this.password});
}

class LoginLogout extends    AuthEvent {
  BuildContext context;

  LoginLogout({required this.context});
}

class RegisterStarted extends    AuthEvent {
  BuildContext context;
  final String email;
  final String fullname;
  final String password;

  RegisterStarted({required this.context, required this.email, required this.fullname, required this.password});
}

