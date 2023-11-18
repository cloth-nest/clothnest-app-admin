import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/statistic.dart';
import 'package:grocery/data/repository/statistic_repository.dart';

part 'statistic_detail_event.dart';
part 'statistic_detail_state.dart';

class StatisticDetailBloc
    extends Bloc<StatisticDetailEvent, StatisticDetailState> {
  final StatisticRepository _statisticRepository;

  StatisticDetailBloc(this._statisticRepository)
      : super(StatisticDetailInitial()) {
    on<StatisticDetailStarted>(_onStarted);
  }

  FutureOr<void> _onStarted(
      StatisticDetailStarted event, Emitter<StatisticDetailState> emit) async {
    emit(StatisticDetailLoading());

    try {
      Statistic? statistic = await _statisticRepository.getStatisticByRange(
          event.beginDate, event.endDate);
      emit(StatisticDetailSuccess(statistic: statistic!));
    } catch (e) {
      emit(StatisticDetailFailure(errorMessage: e.toString()));
    }
  }
}
