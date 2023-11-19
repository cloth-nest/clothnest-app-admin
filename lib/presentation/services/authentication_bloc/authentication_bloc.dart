import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/repository/auth_repository.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_event.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc(
    this._authRepository,
  ) : super(AuthenticationInitial()) {
    on<AuthenticationStarted>((event, emit) async {
      final result = await _authRepository.checkUserLoggined();

      if (result == false) {
        emit(AuthenticatonUnAuthorized());
      } else {
        emit(const AuthenticationAuthorized(role: 'Admin'));
      }
    });

    on<RegistrationButtonPressed>((event, emit) async {
      emit(RegistrationLoading());

      try {
        final result = await _authRepository.register(event.user);

        if (result!.statusCode == 201) {
          emit(RegistrationSuccess());
        } else {
          emit(RegistrationFailure(error: result.message!));
        }
      } catch (e) {
        emit(RegistrationFailure(error: e.toString()));
      }
    });

    on<InitRegistration>((event, emit) => emit(RegistrationInitial()));
  }
}
