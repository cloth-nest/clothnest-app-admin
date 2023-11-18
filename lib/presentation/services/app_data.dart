import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData extends ChangeNotifier {
  late final Future<SharedPreferences> sharedPreferences;

  // Access Token
  String? _accessToken;
  String? get accessToken => _accessToken;
  set accessToken(String? token) {
    if (token == null) return;

    sharedPreferences.then((shared) {
      shared.setString('accessToken', token);
    });
    _accessToken = token;

    initHeaders();
    notifyListeners();
  }

  // Refresh Token
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  set refreshToken(String? token) {
    if (token == null) return;

    sharedPreferences.then((shared) {
      shared.setString('refreshToken', token);
    });
    _refreshToken = token;

    notifyListeners();
  }

  // Remember me
  List<String>? _rememberMe;
  List<String>? get rememberMe => _rememberMe;

  /// list: [email, password]
  set rememberMe(List<String>? rememberMe) {
    if (rememberMe == null) return;

    sharedPreferences.then((shared) {
      shared.setStringList("rememberAccount", rememberMe);
    });
    _rememberMe = rememberMe;
    notifyListeners();
  }

  // Type language
  String? _typeLanguage;
  String? get typeLanguage => _typeLanguage;
  set typeLanguage(String? laguage) {
    if (laguage == null) return;

    sharedPreferences.then((shared) {
      shared.setString("typeLanguage", laguage);
    });
    _typeLanguage = laguage;
    notifyListeners();
  }

  // headers
  Map<String, String> _headers = {'Content-Type': 'application/json'};
  Map<String, String> get headers => _headers;

  AppData(this.sharedPreferences) {
    getTypeLanguage();
    //getToken();

    //initHeaders();
  }

  initHeaders() {
    if (_accessToken != null) {
      _headers = {
        'Accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
      };
      notifyListeners();
    } else {
      _headers = {'Accept': '*/*', 'Content-Type': 'application/json'};
      notifyListeners();
    }
    log("init headers: $_headers");
  }

  getTypeLanguage() async {
    final shared = await sharedPreferences;
    _typeLanguage = shared.getString("typeLanguage");
    log("init language: $_typeLanguage");
    notifyListeners();
  }

  getToken() async {
    final shared = await sharedPreferences;
    _accessToken = shared.getString("accessToken");
    log("init token: $_accessToken");
    notifyListeners();
    initHeaders();
  }

  getRefreshToken() async {
    final shared = await sharedPreferences;
    _refreshToken = shared.getString("refreshToken");
    log("refresh token: $_refreshToken");
    notifyListeners();
    initHeaders();
  }

  Future removeToken() async {
    final shared = await sharedPreferences;
    shared.remove('accessToken');
    _accessToken = null;
    notifyListeners();
  }

  Future removeRememberAccount() async {
    final shared = await SharedPreferences.getInstance();
    shared.remove('rememberAccount');
    _rememberMe = null;
    notifyListeners();
  }
}
