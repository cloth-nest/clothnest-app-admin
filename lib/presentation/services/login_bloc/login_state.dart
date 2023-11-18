part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class LoginSuccess extends LoginState {
  final String role;

  const LoginSuccess({required this.role});

  @override
  List<Object> get props => [role];
}

class LoginLoading extends LoginState {}
