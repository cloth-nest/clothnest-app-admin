import 'dart:developer';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/permission.dart';
import 'package:grocery/data/models/permissions_data.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class PermissionRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlGetPermissionGroups =
      "${localURL}permission/group?page=1&limit=0";
  final String urlGetPermissions = "${localURL}permission?page=1&limit=0";
  final String urlAddGroupPermission = "${localURL}permission/group";

  PermissionRepository(this._appData);

  @override
  ProductType convertToObject(value) {
    return ProductType.fromMap(value);
  }

  Future<PermissionsData?> getPermissionData(
      {int page = 1, int limit = 10}) async {
    try {
      var response = await apiServices.get(
        urlGetPermissionGroups,
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      PermissionsData staffsData = PermissionsData.fromMap(baseResponse.data);

      return staffsData;
    } catch (e) {
      log('error getPermissionData:: $e');

      if (e == 'ForbiddenError') {
        rethrow;
      }
    }
    return null;
  }

  Future<List<Permission>?> getPermissions() async {
    try {
      var response = await apiServices.get(
        urlGetPermissions,
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      return List.from(baseResponse.data['permissions'])
          .map((e) => Permission.fromMap(e))
          .toList();
    } catch (e) {
      log('error getPermissionData:: $e');

      if (e == 'ForbiddenError') {
        rethrow;
      }
    }
    return null;
  }

  Future<void> addPermissionGroup(
      {required String groupPermissionName,
      required List<Permission> permissions}) async {
    try {
      await apiServices.post(
        urlAddGroupPermission,
        {
          'groupPermissionName': groupPermissionName,
          'permissionIds': permissions.map((e) => e.id).toList(),
        },
        _appData.headers,
      );
    } catch (e) {
      log('error addPermissionGroup:: $e');
    }
  }
}
