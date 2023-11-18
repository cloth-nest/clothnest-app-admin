import 'dart:developer';

import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/review.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class ProductRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlAddProduct = "${localURL}Product/add-one";
  final String urlGetProducts = "${localURL}product/get-product-of-category";
  final String urlDeleteProduct = "${localURL}Product";
  final String urlEditProduct = "${localURL}Product";
  final String urlSearchProductInCategory = "${localURL}search";
  final String urlGetReviews = "${localURL}comment/p";

  ProductRepository(this._appData);

  @override
  Product convertToObject(value) {
    return Product.fromMap(value);
  }

  Future<List<Product>?> getProductsByIDCategory(int idCategory) async {
    List<Product> products = [];

    var response;
    try {
      response = await apiServices.get(
        '$urlGetProducts/$idCategory',
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
      log("error get products belong category: $e");
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

  Future<Product> addProduct(Product product) async {
    var response;

    try {
      response = await apiServices.post(
        urlAddProduct,
        product.toMap(),
        _appData.headers,
      );
      print(response);
    } catch (e) {
      log("error add Product: $e");
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);

    return convertToObject(baseResponse.data);
  }

  Future<BaseResponse> deleteProduct(int idProduct) async {
    var response;

    try {
      response = await apiServices.delete(
        '$urlDeleteProduct/$idProduct',
        {},
        _appData.headers,
      );
    } catch (e) {
      log("error delete Product: $e");
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);

    return baseResponse;
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
