import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/detail_product.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/products_data.dart';
import 'package:grocery/data/models/review.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class ProductRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlAddProduct = "${localURL}product/admin";
  final String urlGetProducts = "${localURL}product/admin?page=1&limit=0";
  final String urlGetProductsBelongToCategory = "${localURL}product/category";
  final String urlGetDetailProduct = "${localURL}product/admin";
  final String urlCreatBulkImages = "${localURL}product/admin/image";
  final String urlCreatProductVariant = "${localURL}product/admin/variant";
  final String urlDeleteProduct = "${localURL}Product";
  final String urlEditProduct = "${localURL}Product";
  final String urlSearchProductInCategory = "${localURL}search";
  final String urlGetReviews = "${localURL}comment/p";

  ProductRepository(this._appData);

  @override
  Product convertToObject(value) {
    return Product.fromMap(value);
  }

  Future<ProductsData?> getProductsByIDCategory(int idCategory) async {
    var response;
    try {
      response = await apiServices.get(
        '$urlGetProductsBelongToCategory/$idCategory?page=1&limit=0',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      return ProductsData.fromMap(baseResponse.data);
    } catch (e) {
      log("error get products belong category: $e");
    }

    return null;
  }

  Future<DetailProduct?> getProductDetail(int idProduct) async {
    try {
      var response = await apiServices.get(
        '$urlGetDetailProduct/$idProduct',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.data == null) return null;

      DetailProduct product = DetailProduct.fromMap(baseResponse.data);

      return product;
    } catch (e) {
      log("error getProductDetail: $e");
    }

    return null;
  }

  Future<ProductsData?> getProducts() async {
    var response;
    try {
      response = await apiServices.get(
        urlGetProducts,
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      return ProductsData.fromMap(baseResponse.data);
    } catch (e) {
      log("error get products: $e");

      if (e == 'ForbiddenError') {
        rethrow;
      }
    }

    return null;
  }

  Future<Review?> getReviews(String idProduct) async {
    try {
      final response = await apiServices.get(
        '$urlGetReviews/$idProduct',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);
      Review review = Review.fromMap(baseResponse.data);
      return review;
    } catch (e) {
      log('error get reviews: ${e.toString()}');
    }
    return null;
  }

  Future<List<Product>?> searchProductsByIDCategory(
      int idCategory, String keyword) async {
    List<Product> products = [];
    if (keyword.isEmpty) {
      keyword = " ";
    }
    var response;
    try {
      response = await apiServices.get(
        '$urlSearchProductInCategory/$idCategory?limit=10&page=1&keyword=$keyword',
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.data == null) return null;

      for (var json in baseResponse.data) {
        Product product = Product.fromMap(json);
        products.add(product);
      }

      return products;
    } catch (e) {
      log("error search products belong category: $e");
    }

    return null;
  }

  Future<List<int>> createBulkImages(int idProduct, List<File> files) async {
    _appData.setContentTypeForFormData('multipart/form-data');

    try {
      var request = http.MultipartRequest("POST", Uri.parse(urlCreatBulkImages))
        ..fields['productId'] = idProduct.toString();

      for (File file in files) {
        final mimeTypeData =
            lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])!.split('/');

        request.files.add(
          http.MultipartFile.fromBytes(
            'files',
            file.readAsBytesSync(),
            filename: 'product${file.path}',
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      request.headers.addAll(_appData.headers);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.body));

      return (baseResponse.data as List).map((e) => e['id'] as int).toList();
    } catch (e) {
      log("error add category: $e");
      return [];
    }
  }

  Future<void> addProduct({
    required int productTypeId,
    required int categoryId,
    required String productName,
    required String productDescription,
    required List<Map<String, dynamic>> attributes,
  }) async {
    try {
      final List<Map<String, dynamic>> maps = [];

      for (var attribute in attributes) {
        maps.add({
          'id': attribute['productType'].id,
          'valueId': attribute['attributeValues'].id,
        });
      }

      await apiServices.post(
        urlAddProduct,
        {
          'productTypeId': productTypeId,
          'categoryId': categoryId,
          'productName': productName,
          'productDescription': productDescription,
          'attributes': maps,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error add Product: $e");
    }
  }

  Future<void> createProductVariant({
    required int idProduct,
    required String variantName,
    required String price,
    required List<Map<String, dynamic>>? selectedAttributeValues,
    required List<Map<String, dynamic>>? selectedWarehouses,
    required List<int> imageIds,
    required String weight,
    required String sku,
  }) async {
    try {
      final headers = _appData.headers;
      headers['Accept'] = '*/*';
      headers['Content-Type'] = 'application/json';

      await apiServices.post(
        urlCreatProductVariant,
        {
          "variantName": variantName,
          "productId": idProduct,
          "price": double.tryParse(price),
          "imageIds": imageIds,
          "weight": double.tryParse(weight),
          "sku": sku,
          "variantAttributes": selectedAttributeValues,
          "stocks": selectedWarehouses
        },
        headers,
      );
    } catch (e) {
      log("error createProductVariant: $e");
    }
  }

  Future<Product> editProduct(Product Product) async {
    var response;

    try {
      response = await apiServices.post(
        '$urlEditProduct/${Product.id}',
        Product.toMap(),
        _appData.headers,
      );
    } catch (e) {
      log("error edit Product: $e");
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);

    return convertToObject(baseResponse.data[0]);
  }
}
