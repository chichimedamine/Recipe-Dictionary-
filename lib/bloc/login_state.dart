part of 'login_bloc.dart';

@immutable
sealed class AuthState {}

final class LoginInitial extends AuthState {}

final class LoginLoaded extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginError extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginLoggedOut extends AuthState {}

final class RegisterSuccess extends AuthState {}

final class RegisterError extends AuthState {}
