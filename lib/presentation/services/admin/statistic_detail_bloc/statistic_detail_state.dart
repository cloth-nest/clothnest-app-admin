part of 'statistic_detail_bloc.dart';

abstract class StatisticDetailState extends Equatable {
  const StatisticDetailState();

  @override
  List<Object> get props => [];
}

class StatisticDetailInitial extends StatisticDetailState {}

class StatisticDetailLoading extends StatisticDetailState {}

class StatisticDetailFailure extends StatisticDetailState {
  final String errorMessage;

  const StatisticDetailFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class StatisticDetailSuccess extends StatisticDetailState {
  final Statistic statistic;

  const StatisticDetailSuccess({required this.statistic});

  @override
  List<Object> get props => [statistic];
}
