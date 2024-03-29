import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/staff.dart';
import 'package:grocery/data/models/staffs_data.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class StaffMemberRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlGetStaffMembers = "${localURL}user/staff?page=1&limit=0";
  final String urlInviteStaffMember = "${localURL}user/staff/invite";
  final String urlUpdateGroupPermission = "${localURL}user/staff";
  final String urlGetDetailStaff = "${localURL}user/staff";
  StaffMemberRepository(this._appData);

  @override
  ProductType convertToObject(value) {
    return ProductType.fromMap(value);
  }

  Future<Staff?> getStaffDetail({required int idStaff}) async {
    try {
      final response = await apiServices.get(
        '$urlGetDetailStaff/$idStaff',
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      return Staff.fromMap(baseResponse.data);
    } catch (e) {
      debugPrint('##on error get staff detail: $e');
    }

    return null;
  }

  Future<int> inviteStaffMember({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await apiServices.post(
        urlInviteStaffMember,
        {
          "email": email,
          'firstName': firstName,
          'lastName': lastName,
        },
        _appData.headers,
      );

      return BaseResponse.fromJson(response).data['userId'];
    } catch (e) {
      log("error inviteStaffMember: $e");
      return -1;
    }
  }

  Future<void> updateGroupPermission({
    required int idStaff,
    required List<int> groupPermissionIds,
    required bool isActive,
  }) async {
    try {
      final response = await apiServices.patch(
        '$urlUpdateGroupPermission/$idStaff',
        {
          "isActive": isActive,
          'groupPermissionIds': groupPermissionIds,
        },
        _appData.headers,
      );
      debugPrint('go to here');
    } catch (e) {
      log("error inviteStaffMember: $e");
    }
  }

  Future<StaffsData?> getStaffMemberData({int page = 1, int limit = 10}) async {
    try {
      var response = await apiServices.get(
        urlGetStaffMembers,
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      StaffsData staffsData = StaffsData.fromMap(baseResponse.data);

      return staffsData;
    } catch (e) {
      log('error getStaffMemberData:: $e');

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
