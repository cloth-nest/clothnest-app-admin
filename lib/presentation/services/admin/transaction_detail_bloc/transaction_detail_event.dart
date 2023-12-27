part of 'transaction_detail_bloc.dart';

abstract class TransactionDetailEvent extends Equatable {
  const TransactionDetailEvent();

  @override
  List<Object> get props => [];
}

class TransactionDetailStatusChanged extends TransactionDetailEvent {
  final int orderId;
  final bool isCancelled;
  final String email;

  const TransactionDetailStatusChanged({
    required this.orderId,
    required this.isCancelled,
    required this.email,
  });
}

class TransactionDetailStarted extends TransactionDetailEvent {
  final int orderId;

  const TransactionDetailStarted({
    required this.orderId,
  });
}
