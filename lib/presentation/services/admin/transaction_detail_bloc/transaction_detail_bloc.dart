import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/data.dart';
import 'package:grocery/data/models/notification_request.dart';
import 'package:grocery/data/models/order_detail_model.dart';
import 'package:grocery/data/repository/order_repository.dart';
import 'package:grocery/data/repository/user_repository.dart';
import 'package:grocery/data/services/firebase_service.dart';

part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  final OrderRepository _orderRepository;
  final UserRepository _userRepository;

  FirebaseService firebaseService = FirebaseService();

  TransactionDetailBloc(
    this._orderRepository,
    this._userRepository,
  ) : super(TransactionDetailInitial()) {
    on<TransactionDetailStatusChanged>(_onStatusChanged);
    on<TransactionDetailStarted>(_onStarted);
  }

  FutureOr<void> _onStatusChanged(TransactionDetailStatusChanged event,
      Emitter<TransactionDetailState> emit) async {
    emit(TransactionDetailLoading());

    try {
      await _orderRepository.updateStatus(event.orderId, event.isCancelled);
      String? token =
          await _userRepository.getFirebaseToken(email: event.email);
      String content = "";
      if (event.isCancelled == false) {
        content = 'Your order has been finished';
      } else {
        content = 'Your order has been cancelled';
      }

      await sendNotification(content, token!, event.orderId);
      emit(const TransactionDetailSuccess());
    } catch (e) {
      emit(TransactionDetailFailure(errorMessage: e.toString()));
    }
  }

  Future<void> sendNotification(
      String content, String token, int? idOrder) async {
    Data data = Data(
      title: 'ClothNest Application',
      body: content,
    );

    NotificationRequest notificationRequest = NotificationRequest(
        data: data, to: token, payload: 'order/detail/$idOrder');

    await firebaseService.sendNotification(notificationRequest);
  }

  FutureOr<void> _onStarted(TransactionDetailStarted event,
      Emitter<TransactionDetailState> emit) async {
    try {
      emit(TransactionDetailLoading());

      OrderDetailModel model =
          await _orderRepository.getOrderDetail(event.orderId);

      emit(TransactionDetailLoaded(orderDetailModel: model));
    } catch (e) {
      debugPrint('###error on started: $e');
    }
  }
}
