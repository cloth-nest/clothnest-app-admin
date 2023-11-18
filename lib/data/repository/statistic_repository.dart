import 'dart:developer';
import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/statistic.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class StatisticRepository extends IServiceAPI {
  String urlGetStatistics = 'statistic?types=overview';
  String urlGetStatisticsByRange = 'statistic?types=detail';

  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;

  StatisticRepository(this._appData) {
    urlGetStatistics = localURL + urlGetStatistics;
    urlGetStatisticsByRange = localURL + urlGetStatisticsByRange;
  }

  @override
  Statistic convertToObject(value) {
    return Statistic.fromMap(value);
  }

  Future<Statistic?> getStatistic() async {
    try {
      final response = await apiServices.post(
        urlGetStatistics,
        {"startDate": "", "endDate": ""},
        _appData.headers,
      );
      BaseResponse baseResponse = BaseResponse.fromJson(response);
      Statistic statistic = convertToObject(baseResponse.data);
      return statistic;
    } catch (e) {
      log('Error get statistic: $e');
    }

    return null;
  }

  Future<Statistic?> getStatisticByRange(
      String beginDate, String endDate) async {
    try {
      final response = await apiServices.post(
        urlGetStatisticsByRange,
        {'startDate': beginDate, "endDate": endDate},
        _appData.headers,
      );
      BaseResponse baseResponse = BaseResponse.fromJson(response);
      Statistic statistic = convertToObject(baseResponse.data);
      return statistic;
    } catch (e) {
      log('Error get statistic by range: $e');
    }

    return null;
  }
}
