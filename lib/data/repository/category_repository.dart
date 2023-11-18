import 'dart:developer';

import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class CategoryRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlAddCategory = "${localURL}category/add";
  final String urlGetCategories = "${localURL}category/get-all";
  final String urlDeleteCategory = "${localURL}category";
  final String urlEditCategory = "${localURL}category";

  CategoryRepository(this._appData);

  @override
  Category convertToObject(value) {
    return Category.fromMap(value);
  }

  Future<List<Category>?> getCategories() async {
    List<Category> categories = [];

    var response;
    try {
      response = await apiServices.get(
        urlGetCategories,
        _appData.headers,
      );
    } catch (e) {
      log("error add category: $e");
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);

    if (baseResponse.data == null) return null;

    for (var json in baseResponse.data) {
      Category category = Category.fromMap(json);
      categories.add(category);
    }

    return categories;
  }

  Future<Category> addCategory(Category category) async {
    var response;

    try {
      response = await apiServices.post(
        urlAddCategory,
        category.toMap(),
        _appData.headers,
      );
    } catch (e) {
      log("error add category: $e");
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);

    return convertToObject(baseResponse.data);
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

  Future<Category> editCategory(Category category) async {
    var response;

    try {
      response = await apiServices.post(
        '$urlEditCategory/${category.id}',
        category.toMap(),
        _appData.headers,
      );
    } catch (e) {
      log("error edit category: $e");
    }

    BaseResponse baseResponse = BaseResponse.fromJson(response);

    return convertToObject(baseResponse.data[0]);
  }
}
