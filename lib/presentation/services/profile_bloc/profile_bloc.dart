import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery/data/models/user.dart';
import 'package:grocery/data/repository/auth_repository.dart';
import 'package:grocery/data/repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  ProfileBloc(this._authRepository, this._userRepository)
      : super(ProfileInitial()) {
    on<ProfileLoggedOut>(_onLoggedOut);
    on<ProfileFetched>(_onFetched);
  }

  void _onLoggedOut(event, emit) async {
    emit(ProfileLoading());

    try {
      _authRepository.logout();
      emit(ProfileLoggoutSuccess());
    } catch (e) {
      emit(ProfileFailure(errorMessage: e.toString()));
    }
  }

  void _onFetched(ProfileFetched event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      User? user = await _userRepository.getUserInfo();
      emit(ProfileSuccess(user: user!));
    } catch (e) {
      emit(ProfileFailure(errorMessage: e.toString()));
    }
  }
}
