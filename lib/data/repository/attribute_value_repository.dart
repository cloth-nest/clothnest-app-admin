import 'dart:developer';
import 'package:grocery/data/models/attribute_value.dart';
import 'package:grocery/data/models/attribute_values_data.dart';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class AttributeValueRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlGetAttributeValues = "${localURL}product/attributes/values";
  final String urlAddProductAttribute = "${localURL}product/attributes/values";
  final String urlGetCategories = "${localURL}category/admin?";
  final String urlDeleteCategory = "${localURL}category";
  final String urlEditCategory = "${localURL}category";
  final String urlGetOneCategory = "${localURL}category";
  final String urlUpdateProductAttribute = "${localURL}product/attributes";

  AttributeValueRepository(this._appData);

  @override
  AttributeValue convertToObject(value) {
    return AttributeValue.fromMap(value);
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

  Future<void> addAttributeValue(String attribute, int id) async {
    try {
      await apiServices.post(
        urlAddProductAttribute,
        {
          'attributeValue': attribute,
          'attributeId': id,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error addProductAttribute: $e");
    }
  }

  Future<void> updateProductAttribute(String attribute, int id) async {
    try {
      await apiServices.patch(
        '$urlUpdateProductAttribute/$id',
        {
          'productAttributeName': attribute,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error updateProductAttribute: $e");
    }
  }

  Future<AttributeValuesData?> getAttributeValuesData(int id,
      {int page = 1, int limit = 10}) async {
    try {
      var response = await apiServices.get(
        '$urlGetAttributeValues/$id?limit=0&page=$page',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      AttributeValuesData attributesData =
          AttributeValuesData.fromMap(baseResponse.data);

      return attributesData;
    } catch (e) {
      log('error getAttributeValues:: $e');

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
