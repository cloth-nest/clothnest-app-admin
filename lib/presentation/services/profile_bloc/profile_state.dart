part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String errorMessage;

  const ProfileFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ProfileSuccess extends ProfileState {
  final User user;

  const ProfileSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileLoggoutSuccess extends ProfileState {}
