part of 'transaction_detail_bloc.dart';

abstract class TransactionDetailEvent extends Equatable {
  const TransactionDetailEvent();

  @override
  List<Object> get props => [];
}

class TransactionDetailStatusChanged extends TransactionDetailEvent {
  final String orderId;
  final String email;
  final String newStatus;

  const TransactionDetailStatusChanged({
    required this.orderId,
    required this.newStatus,
    required this.email,
  });
}
