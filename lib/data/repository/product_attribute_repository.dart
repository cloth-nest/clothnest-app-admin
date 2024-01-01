import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/attribute.dart';
import 'package:grocery/data/models/attributes_data.dart';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class ProductAttributeRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlGetProductAttributes = "${localURL}product/attributes";
  final String urlAddProductAttribute = "${localURL}product/attributes";
  final String urlGetCategories = "${localURL}category/admin?";
  final String urlDeleteCategory = "${localURL}category";
  final String urlEditCategory = "${localURL}category";
  final String urlGetOneCategory = "${localURL}category";

  ProductAttributeRepository(this._appData);

  @override
  Attribute convertToObject(value) {
    return Attribute.fromMap(value);
  }

  Future<BaseResponse> deleteCategory(int idCategory) async {
    var response;

    try {
      response = await apiServices.delete(
        '$urlDeleteCategory/$idCategory',
        {},
        _appData.headers,
      );
    } catch (e) {
      log("error delete category: $e");
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);

    return baseResponse;
  }

  Future<void> addProductAttribute(String attribute) async {
    try {
      final response = await apiServices.post(
        urlAddProductAttribute,
        {
          'productAttributeName': attribute,
        },
        _appData.headers,
      );
      debugPrint('##go to here');
    } catch (e) {
      log("error addProductAttribute: $e");
    }
  }

  Future<AttributesData?> getProductAttributesData(
      {int page = 1, int limit = 10}) async {
    try {
      var response = await apiServices.get(
        '$urlGetProductAttributes?limit=0&page=$page',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      AttributesData attributesData = AttributesData.fromMap(baseResponse.data);

      return attributesData;
    } catch (e) {
      log('error getProductAttributes:: $e');

      if (e == 'ForbiddenError') {
        rethrow;
      }
    }
    return null;
  }

  // Future<Category?> getOneCategory(int id) async {
  //   try {
  //     var response;

  //     try {
  //       response = await apiServices.get(
  //         '$urlGetOneCategory/$id',
  //         _appData.headers,
  //       );
  //     } catch (e) {
  //       log("error get one category: $e");
  //     }

  //     BaseResponse baseResponse = BaseResponse.fromJson(response);

  //     if (baseResponse.data == null) return null;

  //     return convertToObject(baseResponse.data);
  //   } catch (e) {
  //     log('get first categories: $e');
  //   }
  //   return null;
  // }
}
