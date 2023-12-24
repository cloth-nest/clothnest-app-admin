import 'dart:developer';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/product_types_data.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class ProductTypeRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlGetProductTypes = "${localURL}product/type?limit=0&page=1";
  final String urlGetAllAttributes = "${localURL}product/type";

  final String urlAddProductType = "${localURL}product/type";
  final String urlGetCategories = "${localURL}category/admin?";
  final String urlDeleteCategory = "${localURL}category";
  final String urlEditCategory = "${localURL}category";
  final String urlGetOneCategory = "${localURL}category";
  final String urlUpdateProductAttribute = "${localURL}product/attributes";

  ProductTypeRepository(this._appData);

  @override
  ProductType convertToObject(value) {
    return ProductType.fromMap(value);
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

  Future<void> addProductType(String productType) async {
    try {
      await apiServices.post(
        urlAddProductType,
        {
          'productTypeName': productType,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error addProductType: $e");
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

  Future<ProductTypesData?> getProductTypeData(
      {int page = 1, int limit = 10}) async {
    try {
      var response = await apiServices.get(
        urlGetProductTypes,
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);
      if (baseResponse.data == null) return null;

      ProductTypesData productTypesData =
          ProductTypesData.fromMap(baseResponse.data);

      return productTypesData;
    } catch (e) {
      log('error getProductTypeData:: $e');
    }
    return null;
  }

  Future<List<ProductType>?> getAllProductAttributes(
      {required int productTypeId}) async {
    try {
      var response = await apiServices.get(
        '$urlGetAllAttributes/$productTypeId',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);
      if (baseResponse.data == null) return null;

      List<ProductType>? result =
          List.from(baseResponse.data['productAttributes'])
              .map((e) => ProductType.fromMap(e))
              .toList();
      return result;
    } catch (e) {
      log('error getAllProductAttributes:: $e');
    }
    return null;
  }

  Future<List<ProductType>?> getAllVariantAttributes(
      {required int productTypeId}) async {
    try {
      var response = await apiServices.get(
        '$urlGetAllAttributes/$productTypeId',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);
      if (baseResponse.data == null) return null;

      List<ProductType>? result =
          List.from(baseResponse.data['variantAttributes'])
              .map((e) => ProductType.fromMap(e))
              .toList();
      return result;
    } catch (e) {
      log('error getAllVariantAttributes:: $e');
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
