import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/data/models/order_model.dart';
import 'package:grocery/data/models/transaction.dart';
import 'package:grocery/data/repository/order_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final OrderRepository _orderRepository;

  List<OrderModel> orders = [];
  List<String> filterStatuses = ['All'];
  String sort = 'Nearest Date';

  TransactionBloc(this._orderRepository)
      : super(
          const TransactionInitial(filterStatus: ['All'], sort: 'Nearest Date'),
        ) {
    on<TransactionEvent>(_onStarted);
    on<TransactionSorted>(_onSorted);
    on<TransactionFiltered>(_onFiltered);
    on<TransactionEditted>(_onEditted);
  }

  FutureOr<void> _onStarted(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading(filterStatus: filterStatuses, sort: sort));

    try {
      List<OrderModel> result = await _orderRepository.getAllOrders(
        filterStatuses,
        sort == 'Nearest Date' ? 'nearest' : 'farest',
      );
      orders = result;
      emit(TransactionSuccess(
        orders: [...orders],
        sort: sort,
        filterStatus: filterStatuses,
      ));
    } catch (e) {
      emit(TransactionFailure(
          errorMessage: e.toString(),
          sort: sort,
          filterStatus: filterStatuses));
    }
  }

  FutureOr<void> _onSorted(
      TransactionSorted event, Emitter<TransactionState> emit) async {
    log('sort: ${event.sortValue}');
    sort = event.sortValue;
    emit(TransactionLoading(filterStatus: filterStatuses, sort: sort));

    try {
      // List<Order> result = await _orderRepository.getAllOrders(
      //   filterStatuses,
      //   sort == 'Nearest Date' ? 'nearest' : 'farest',
      // );
      // orders = [];
      // orders = result;

      // emit(TransactionSuccess(
      //   orders: [...result],
      //   sort: sort,
      //   filterStatus: filterStatuses,
      // ));
    } catch (e) {
      emit(
        TransactionFailure(
          errorMessage: e.toString(),
          sort: sort,
          filterStatus: filterStatuses,
        ),
      );
    }
  }

  FutureOr<void> _onFiltered(
      TransactionFiltered event, Emitter<TransactionState> emit) async {
    filterStatuses = event.filterValues;

    emit(TransactionLoading(filterStatus: filterStatuses, sort: sort));

    try {
      // List<Order> result = await _orderRepository.getAllOrders(
      //   filterStatuses,
      //   sort == 'Nearest Date' ? 'nearest' : 'farest',
      // );

      // orders = [];
      // orders = result;

      // emit(TransactionSuccess(
      //   orders: [...orders],
      //   sort: sort,
      //   filterStatus: filterStatuses,
      // ));
    } catch (e) {
      emit(
        TransactionFailure(
          errorMessage: e.toString(),
          sort: sort,
          filterStatus: filterStatuses,
        ),
      );
    }
  }

  FutureOr<void> _onEditted(
      TransactionEditted event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading(filterStatus: filterStatuses, sort: sort));

    try {
      // List<Order> result = await _orderRepository.getAllOrders(
      //   filterStatuses,
      //   sort == 'Nearest Date' ? 'nearest' : 'farest',
      // );
      // orders = result;
      // emit(TransactionSuccess(
      //   orders: [...result],
      //   sort: sort,
      //   filterStatus: filterStatuses,
      // ));
    } catch (e) {
      emit(TransactionFailure(
          errorMessage: e.toString(),
          sort: sort,
          filterStatus: filterStatuses));
    }
  }
}
