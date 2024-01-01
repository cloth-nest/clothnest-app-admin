import 'dart:developer';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/warehouse.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class WarehouseRepository extends IServiceAPI {
  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;
  final String urlGetWarehouses = "${localURL}warehouse";
  final String urlCreateWarehouses = "${localURL}warehouse";

  WarehouseRepository(this._appData);

  @override
  Warehouse convertToObject(value) {
    return Warehouse.fromMap(value);
  }

  Future<List<Warehouse>?> getWarehouses() async {
    try {
      var response = await apiServices.get(
        urlGetWarehouses,
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      if (baseResponse.data == null) return null;

      return (baseResponse.data as List)
          .map((e) => Warehouse.fromMap(e))
          .toList();
    } catch (e) {
      log('error getWarehouses:: $e');

      if (e == 'ForbiddenError') {
        rethrow;
      }
    }
    return null;
  }

  Future<void> createWarehouses({required String warehouseName}) async {
    try {
      await apiServices.post(
        urlCreateWarehouses,
        {
          'warehouseName': warehouseName,
        },
        _appData.headers,
      );
    } catch (e) {
      log('error createWarehouses:: $e');
    }
  }
}
