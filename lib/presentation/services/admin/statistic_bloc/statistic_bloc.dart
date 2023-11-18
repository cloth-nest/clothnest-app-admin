import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/statistic.dart';
import 'package:grocery/data/repository/statistic_repository.dart';

part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final StatisticRepository _statisticRepository;

  StatisticBloc(this._statisticRepository) : super(StatisticInitial()) {
    on<StatisticStarted>(_onStarted);
  }

  FutureOr<void> _onStarted(
      StatisticStarted event, Emitter<StatisticState> emit) async {
    emit(StatisticLoading());

    try {
      Statistic? statistic = await _statisticRepository.getStatistic();
      emit(StatisticSuccess(statistic: statistic!));
    } catch (e) {
      emit(StatisticFailure(errorMessage: e.toString()));
    }
  }
}
