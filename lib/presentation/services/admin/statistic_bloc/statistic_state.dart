part of 'statistic_bloc.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {}

class StatisticLoading extends StatisticState {}

class StatisticFailure extends StatisticState {
  final String errorMessage;

  const StatisticFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class StatisticSuccess extends StatisticState {
  final Statistic statistic;

  const StatisticSuccess({required this.statistic});

  @override
  List<Object> get props => [statistic];
}
