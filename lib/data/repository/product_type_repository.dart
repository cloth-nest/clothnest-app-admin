import 'dart:developer';
import 'dart:io';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/product_types_data.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:mime/mime.dart';

class ProductTypeRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlGetProductTypes = "${localURL}product/type?limit=0&page=1";
  final String urlGetAllAttributes = "${localURL}product/type";
  final String urlAddAttribute = "${localURL}product/type/attribute";
  final String urlAddProductType = "${localURL}product/type";
  final String urlGetCategories = "${localURL}category/admin?";
  final String urlDeleteProductType = "${localURL}product/type";
  final String urlEditCategory = "${localURL}category";
  final String urlGetOneCategory = "${localURL}category";
  final String urlUpdateProductAttribute = "${localURL}product/attributes";
  final String urlRemoveAttribute = "${localURL}product/type/attribute";
  ProductTypeRepository(this._appData);

  @override
  ProductType convertToObject(value) {
    return ProductType.fromMap(value);
  }

  Future<void> deleteProductType(int idProductType) async {
    try {
      var response = await apiServices.delete(
        '$urlDeleteProductType/$idProductType',
        {},
        _appData.headers,
      );
      BaseResponse baseResponse = BaseResponse.fromJson(response);
      if (baseResponse.message == 'ProductTypeError') {
        throw response['error']['message'];
      }
    } catch (e) {
      log("error delete product type: $e");
      rethrow;
    }
  }

  Future<void> removeAttribute(
    int idProductType,
    String attributeType,
    List<int> productAttributeIds,
  ) async {
    try {
      final response = await apiServices.delete(
        urlRemoveAttribute,
        {
          "productTypeId": idProductType,
          "attributeType": attributeType,
          "productAttributeIds": productAttributeIds
        },
        _appData.headers,
      );
      print('hiih');
    } catch (e) {
      log("error remove attribute: $e");
    }
  }

  Future<void> addProductType(
    String productType,
    File sizeChartImage,
  ) async {
    try {
      _appData.setContentTypeForFormData('multipart/form-data');
      var request = http.MultipartRequest("POST", Uri.parse(urlAddProductType))
        ..fields['productTypeName'] = productType;

      final mimeTypeData =
          lookupMimeType(sizeChartImage.path, headerBytes: [0xFF, 0xD8])!
              .split('/');

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          sizeChartImage.readAsBytesSync(),
          filename: 'abc',
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );

      request.headers.addAll(_appData.headers);
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
    } catch (e) {
      log("error add product type: $e");
    }

    _appData.resetHeader();

    // try {
    //   await apiServices.post(
    //     urlAddProductType,
    //     {
    //       'productTypeName': productType,
    //     },
    //     _appData.headers,
    //   );
    // } catch (e) {
    //   log("error addProductType: $e");
    // }
  }

  Future<void> addAttribute({
    required int productTypeId,
    required String attributeType,
    required List<int> productAttributeIds,
  }) async {
    try {
      await apiServices.post(
        urlAddAttribute,
        {
          'productTypeId': productTypeId,
          'attributeType': attributeType,
          'productAttributeIds': productAttributeIds,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error addAttribute: $e");
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

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      ProductTypesData productTypesData =
          ProductTypesData.fromMap(baseResponse.data);

      return productTypesData;
    } catch (e) {
      log('error getProductTypeData:: $e');
      if (e == 'ForbiddenError') {
        rethrow;
      }
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
}
