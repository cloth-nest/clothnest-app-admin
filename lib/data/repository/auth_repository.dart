import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/user.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/data/services/firebase_service.dart';
import 'package:grocery/presentation/services/app_data.dart';

class AuthRepository extends IServiceAPI {
  String urlRegister = 'auth/register';
  String urlLogin = 'auth/login';
  String urlRefreshToken = 'auth/refresh-token';
  String urlLogout = "auth/logout";

  final BaseApiServices apiServices = NetworkApiService();
  final FirebaseService firebaseService = FirebaseService();
  final AppData _appData;

  AuthRepository(this._appData) {
    urlRegister = localURL + urlRegister;
    urlLogin = localURL + urlLogin;
    urlRefreshToken = localURL + urlRefreshToken;
    urlLogout = localURL + urlLogout;
  }

  @override
  User convertToObject(value) {
    return User.fromMap(value);
  }

  Future<void> logout() async {
    try {
      await apiServices.delete(
        urlLogout,
        {},
        _appData.headers,
      );
    } catch (e) {
      log('Error logout: $e');
    }
  }

  Future<BaseResponse?> register(User user) async {
    try {
      final response = await apiServices.post(
        urlRegister,
        user.toMap(),
        _appData.headers,
      );

      final result = BaseResponse.fromJson(response);
      print(result);
      return result;
    } catch (e) {
      print('Error register: $e');
      return null;
    }
  }

  Future<BaseResponse?> login(String email, String password) async {
    try {
      final response = await apiServices.post(
        urlLogin,
        {
          "email": email,
          "password": password,
        },
        _appData.headers,
      );
      await firebaseService.saveToken(email);

      return BaseResponse.fromJson(response);
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  Future<String?> refreshToken() async {
    await _appData.getRefreshToken();
    try {
      final response = await apiServices.post(
        urlRefreshToken,
        {
          "refreshToken": _appData.refreshToken,
        },
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);
      if (baseResponse.statusCode == 200) {
        return baseResponse.data['accessToken'];
      }
    } catch (e) {
      print('Error refreshToken: $e');
    }
    return null;
  }

  Future<bool> checkUserLoggined() async {
    await _appData.getToken();
    String? token = _appData.accessToken ?? '';

    if (token.isEmpty) {
      return false;
    }

    try {
      // Verify a token
      JWT.verify(token, SecretKey(secretKey));
    } on JWTExpiredException {
      String? newAccessToken = await refreshToken();

      if (newAccessToken != null) {
        log("AT: $newAccessToken");
        saveAccessToken(newAccessToken);
      }
    }

    token = _appData.accessToken ?? '';

    return true;
  }

  String getRole() {
    JWT jwt = JWT.decode(_appData.accessToken!);
    dynamic payload = jwt.payload;
    return payload['user']['role'];
  }

  void saveAccessToken(String accessToken) {
    _appData.accessToken = accessToken;
  }

  void saveRefreshToken(String refreshToken) {
    _appData.refreshToken = refreshToken;
  }
}
