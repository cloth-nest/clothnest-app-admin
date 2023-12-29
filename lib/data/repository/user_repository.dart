import 'dart:developer';

import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/user.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class UserRepository extends IServiceAPI {
  String urlGetInfo = "user/get-info";
  String urlUpdateAvatar = "user/update-avatar";
  String urlUpdateInfo = "user/update-info";
  String urlGetFirebaseToken = "user/ft";

  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;

  UserRepository(this._appData) {
    urlGetInfo = localURL + urlGetInfo;
    urlUpdateAvatar = localURL + urlUpdateAvatar;
    urlUpdateInfo = localURL + urlUpdateInfo;
    urlGetFirebaseToken = localURL + urlGetFirebaseToken;
  }

  @override
  User convertToObject(value) {
    return User.fromJson(value);
  }

  Future<User?> getUserInfo() async {
    try {
      final response = await apiServices.get(
        urlGetInfo,
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      User user = User.fromMap(baseResponse.data);

      return user;
    } catch (e) {
      log("error get user info: $e");
    }

    return null;
  }

  Future<String?> getFirebaseToken({required String email}) async {
    try {
      final response = await apiServices.post(
        urlGetFirebaseToken,
        {
          'email': email,
        },
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      return baseResponse.data['firebaseToken'];
    } catch (e) {
      log("error get firebase token: $e");
    }

    return null;
  }

  Future<void> updateAvatar(String avatarUrl) async {
    try {
      final response = await apiServices.post(
        urlUpdateAvatar,
        {"avatar": avatarUrl},
        _appData.headers,
      );
      print(response);
    } catch (e) {
      log("error update avatar info: $e");
    }
  }

  Future<void> updateUserInfo(
      String firstName, String lastName, String phoneNum) async {
    try {
      await apiServices.post(
        urlUpdateInfo,
        {
          "firstName": firstName,
          "lastName": lastName,
          "phoneNum": phoneNum,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error update info: $e");
    }
  }
}
