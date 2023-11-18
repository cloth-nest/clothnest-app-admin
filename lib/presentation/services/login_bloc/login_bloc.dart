import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/repository/auth_repository.dart';
import 'package:grocery/data/response/base_response.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        BaseResponse? baseResponse =
            await _authRepository.login(event.email, event.password);

        if (baseResponse!.statusCode == 201) {
          _authRepository.saveAccessToken(baseResponse.data['accessToken']);
          _authRepository.saveRefreshToken(baseResponse.data['refreshToken']);
          emit(LoginSuccess(role: _authRepository.getRole()));
        } else {
          emit(LoginFailure(error: baseResponse.message!));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
