import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/data/repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  List<Order> orders = [];

  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<OrderStarted>(_onStarted);
  }

  FutureOr<void> _onStarted(
      OrderStarted event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    try {
      List<Order> result = await _orderRepository.getAllOrderBelongToUser();
      orders = result;
      emit(OrderSuccess(orders: [...orders]));
    } catch (e) {
      emit(OrderFailure(errorMessage: e.toString()));
    }
  }
}
