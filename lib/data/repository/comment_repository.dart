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

  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;

  CommentRepository(this._appData) {
    urlCreateComment = localURL + urlCreateComment;
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
      log('Error get coupons: $e');
    }
  }
}
