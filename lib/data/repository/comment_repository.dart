import 'dart:developer';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/comment.dart';
import 'package:grocery/data/models/coupon.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class CommentRepository extends IServiceAPI {
  String urlCreateComment = 'comment';
  String urlGetComments = 'review/product';

  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;

  CommentRepository(this._appData) {
    urlCreateComment = localURL + urlCreateComment;
    urlGetComments = localURL + urlGetComments;
  }

  @override
  Coupon convertToObject(value) {
    return Coupon.fromMap(value);
  }

  Future<void> createComment(Comment comment) async {
    try {
      await apiServices.post(
        urlCreateComment,
        comment.toMap(),
        _appData.headers,
      );
    } catch (e) {
      log('Error createComment: $e');
    }
  }

  Future<List<Comment>> getComments({required int idProduct}) async {
    try {
      final response = await apiServices.get(
        '$urlGetComments/$idProduct?page=1&limit=0',
        _appData.headers,
      );
      BaseResponse json = BaseResponse.fromJson(response);

      if (json.data == null) return [];

      return (json.data['reviews'] as List)
          .map((e) => Comment.fromMap(e))
          .toList();
    } catch (e) {
      log('Error getComments: $e');
    }

    return [];
  }
}
