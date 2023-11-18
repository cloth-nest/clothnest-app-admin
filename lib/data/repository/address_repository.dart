import 'dart:convert';
import 'dart:developer';

import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/address.dart';
import 'package:grocery/data/models/place.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';
import 'package:http/http.dart' as http;

class AddressRepository extends IServiceAPI {
  String urlProvince = "$addressURL/p";
  String urlDistrict = "$addressURL/p";
  String urlWard = "$addressURL/d";
  String urlGetAllAdresses = "address/get-all";
  String urlCreateNewAddress = "address/add";
  String urlUpdateAddress = "address";
  String urlDeleteAddress = "address";

  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;

  AddressRepository(this._appData) {
    urlGetAllAdresses = localURL + urlGetAllAdresses;
    urlCreateNewAddress = localURL + urlCreateNewAddress;
    urlUpdateAddress = localURL + urlUpdateAddress;
    urlDeleteAddress = localURL + urlDeleteAddress;
  }

  @override
  Place convertToObject(value) {
    return Place.fromJson(value);
  }

  Future<Address?> createNewAddress(Address address) async {
    try {
      final response = await apiServices.post(
        urlCreateNewAddress,
        address.toMap(),
        _appData.headers,
      );
      final BaseResponse baseResponse = BaseResponse.fromJson(response);
      Address newAddress = Address.fromMap(baseResponse.data);
      return newAddress;
    } catch (e) {
      log('error create new address: $e');
    }

    return null;
  }

  Future<void> deleteAddress(int id) async {
    try {
      await apiServices.delete(
        '$urlDeleteAddress/$id',
        {},
        _appData.headers,
      );
    } catch (e) {
      log('error delete address: $e');
    }
  }

  Future<Address?> updateAddress(Address address) async {
    try {
      final response = await apiServices.post(
        "$urlUpdateAddress/${address.id}",
        address.toMap(),
        _appData.headers,
      );
      final BaseResponse baseResponse = BaseResponse.fromJson(response);
      Address newAddress = Address.fromMap(baseResponse.data[0]);
      return newAddress;
    } catch (e) {
      log('error update address: $e');
    }

    return null;
  }

  Future<List<Address>> getAddresses() async {
    List<Address> addresses = [];
    try {
      final response = await apiServices.get(
        urlGetAllAdresses,
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      for (var json in baseResponse.data) {
        Address address = Address.fromMap(json);
        addresses.add(address);
      }
    } catch (e) {
      log("error get addresses: $e");
    }

    return addresses;
  }

  Future<List<Place>> getProvinces() async {
    List<dynamic> responseJson;
    List<Place> provinces = [];

    try {
      final response = await http.get(Uri.parse(urlProvince));
      responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      provinces = responseJson.map((e) => Place.fromJson(e)).toList();
    } on Exception catch (_) {}
    return provinces;
  }

  Future<List<Place>> getDistricts(int code) async {
    dynamic responseJson;
    List<Place> districts = [];

    try {
      final response = await http.get(Uri.parse('$urlDistrict/$code?depth=2'));
      responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      districts = (responseJson['districts'] as List<dynamic>)
          .map((e) => Place.fromJson(e))
          .toList();
    } on Exception catch (_) {}
    return districts;
  }

  Future<List<Place>> getWards(int code) async {
    dynamic responseJson;
    List<Place> districts = [];
    try {
      final response = await http.get(Uri.parse('$urlWard/$code?depth=2'));
      responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      districts = (responseJson['wards'] as List<dynamic>)
          .map((e) => Place.fromJson(e))
          .toList();
    } on Exception catch (_) {}
    return districts;
  }
}
