part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoggedOut extends ProfileEvent {}

class ProfileFetched extends ProfileEvent {}
