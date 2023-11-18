// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'statistic_detail_bloc.dart';

abstract class StatisticDetailEvent extends Equatable {
  const StatisticDetailEvent();

  @override
  List<Object> get props => [];
}

class StatisticDetailStarted extends StatisticDetailEvent {
  final String beginDate;
  final String endDate;
  const StatisticDetailStarted({
    required this.beginDate,
    required this.endDate,
  });
  @override
  List<Object> get props => [beginDate, endDate];
}
