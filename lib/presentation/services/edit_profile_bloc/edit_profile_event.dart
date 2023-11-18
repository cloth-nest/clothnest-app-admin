part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class EditProfileStarted extends EditProfileEvent {
  final User user;

  const EditProfileStarted({required this.user});

  @override
  List<Object> get props => [user];
}

class AvatarChanged extends EditProfileEvent {
  final String newAvatarUrl;

  const AvatarChanged({required this.newAvatarUrl});

  @override
  List<Object> get props => [newAvatarUrl];
}

class EditProfileSaved extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final String phoneNum;

  const EditProfileSaved({
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
  });

  @override
  List<Object> get props => [firstName, lastName, phoneNum];
}
