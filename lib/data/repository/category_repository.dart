import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:grocery/data/models/categories_data.dart';
import 'package:http/http.dart' as http;
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:mime/mime.dart';

class CategoryRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlAddCategory = "${localURL}category";
  final String urlGetCategories = "${localURL}category/admin?";
  final String urlGetFirstCategories = "${localURL}category?level=1";
  final String urlDeleteCategory = "${localURL}category";
  final String urlEditCategory = "${localURL}category";
  final String urlGetOneCategory = "${localURL}category";

  CategoryRepository(this._appData);

  @override
  Category convertToObject(value) {
    return Category.fromMap(value);
  }

  Future<CategoriesData?> getCategories(
      {int page = 1, int limit = 10, int? parentId}) async {
    var response;

    try {
      response = await apiServices.get(
        parentId == null
            ? '${urlGetCategories}level=0&page=$page&limit=$limit'
            : '${urlGetCategories}page=$page&limit=$limit&parentId=$parentId',
        _appData.headers,
      );
    } catch (e) {
      log("error get categories: $e");
    }
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.data == null) return null;

    CategoriesData categoriesData = CategoriesData.fromMap(baseResponse.data);

    return categoriesData;
  }

  Future<Category> addCategory(String name, File? file, int? parentId) async {
    var response;
    _appData.setContentTypeForFormData('multipart/form-data');

    try {
      var request = http.MultipartRequest("POST", Uri.parse(urlAddCategory))
        ..fields['name'] = name;

      if (parentId != null) {
        request.fields['parentId'] = parentId.toString();
      }

      if (file != null) {
        final mimeTypeData =
            lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])!.split('/');

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.readAsBytesSync(),
            filename: 'abc',
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      request.headers.addAll(_appData.headers);
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } catch (e) {
      log("error add category: $e");
    }

    BaseResponse baseResponse =
        BaseResponse.fromJson(jsonDecode(response.body));

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

  Future<Category?> editCategory(Category category, File? imageFile) async {
    var response;
    _appData.setContentTypeForFormData('multipart/form-data');

    try {
      var request = http.MultipartRequest(
          "PATCH", Uri.parse('$urlEditCategory/${category.id}'))
        ..fields['name'] = category.name;

      if (imageFile != null) {
        final mimeTypeData =
            lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!
                .split('/');

        request.files.add(
          http.MultipartFile.fromBytes(
            'bgImg',
            imageFile.readAsBytesSync(),
            filename: 'abc',
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      request.headers.addAll(_appData.headers);
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } catch (e) {
      log("error edit category: $e");
    }

    BaseResponse baseResponse =
        BaseResponse.fromJson(jsonDecode(response.body));
    return null;
  }

  Future<List<Category>?> getFirstCategories() async {
    try {
      var response;

      try {
        response = await apiServices.get(
          urlGetFirstCategories,
          _appData.headers,
        );
      } catch (e) {
        log("error get categories: $e");
      }

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.data == null) return null;

      List<Category> categories =
          List.from(baseResponse.data).map((e) => Category.fromMap(e)).toList();

      return categories;
    } catch (e) {
      log('get first categories: $e');
    }
    return null;
  }

  Future<Category?> getOneCategory(int id) async {
    try {
      var response;

      try {
        response = await apiServices.get(
          '$urlGetOneCategory/$id',
          _appData.headers,
        );
      } catch (e) {
        log("error get one category: $e");
      }

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.data == null) return null;

      return convertToObject(baseResponse.data);
    } catch (e) {
      log('get first categories: $e');
    }
    return null;
  }
}
