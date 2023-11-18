part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess();

  @override
  List<Object> get props => [];
}

class EditProfileFailure extends EditProfileState {
  final String errorMessage;

  const EditProfileFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class EditProfileLoading extends EditProfileState {}
