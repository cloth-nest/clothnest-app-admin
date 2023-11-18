import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationAuthorized extends AuthenticationState {
  final String role;

  const AuthenticationAuthorized({required this.role});

  @override
  List<Object> get props => [role];
}

class AuthenticatonUnAuthorized extends AuthenticationState {}

// [REGISTRATION STATE]
class RegistrationFailure extends AuthenticationState {
  final String error;
  const RegistrationFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class RegistrationInitial extends AuthenticationState {}

class RegistrationSuccess extends AuthenticationState {}

class RegistrationLoading extends AuthenticationState {}
