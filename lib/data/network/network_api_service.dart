import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:grocery/data/app_exception.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiServices {
  /// Delete methods
  @override
  Future delete(String url, data, headers) async {
    dynamic responseJson;

    try {
      final response = await http.delete(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      );
      // .timeout(const Duration(seconds: 100));

      responseJson = jsonDecode(response.body);
    } on SocketException {
      throw FetchDataException('Error Delete Data By API');
    }
    return responseJson;
  }

  /// Get methods
  @override
  Future get(String url, headers) async {
    dynamic responseJson;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      // .timeout(const Duration(seconds: 100));

      responseJson = jsonDecode(response.body);
    } on SocketException {
      log('Error Get Data From API');
      throw FetchDataException('Error Get Data From API');
    }
    return responseJson;
  }

  /// Post methods
  @override
  Future post(String url, data, headers) async {
    dynamic responseJson;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: data != null ? jsonEncode(data) : null,
        headers: headers,
      );
      // .timeout(const Duration(seconds: 100));

      responseJson = jsonDecode(response.body);
    } on SocketException {
      throw FetchDataException('Error Post To Server');
    }
    return responseJson;
  }

  /// Put methods
  @override
  Future put(String url, data, headers) async {
    dynamic responseJson;
    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      );
      // .timeout(const Duration(seconds: 100));
      responseJson = jsonDecode(response.body);
    } on SocketException {
      log('Error Put To Server');
      throw FetchDataException('Error Put To Server');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
      case 404:
      case 500:
      default:
        final responseJson = jsonDecode(response.body);
        return responseJson;
    }
  }
}
