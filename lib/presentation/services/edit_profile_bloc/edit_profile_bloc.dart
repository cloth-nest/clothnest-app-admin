import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/user.dart';
import 'package:grocery/data/repository/user_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserRepository _userRepository;

  EditProfileBloc(this._userRepository) : super(EditProfileInitial()) {
    on<AvatarChanged>(_onAvatarChanged);
    on<EditProfileStarted>(_onStarted);
    on<EditProfileSaved>(_onSaved);
  }

  FutureOr<void> _onAvatarChanged(
      AvatarChanged event, Emitter<EditProfileState> emit) async {
    try {
      await _userRepository.updateAvatar(event.newAvatarUrl);
    } catch (e) {
      emit(EditProfileFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onStarted(
      EditProfileStarted event, Emitter<EditProfileState> emit) {
    //emit(EditProfileSuccess(user: event.user));
  }

  FutureOr<void> _onSaved(
      EditProfileSaved event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());
    try {
      await _userRepository.updateUserInfo(
          event.firstName, event.lastName, event.phoneNum);
      emit(const EditProfileSuccess());
    } catch (e) {
      emit(EditProfileFailure(errorMessage: e.toString()));
    }
  }
}
