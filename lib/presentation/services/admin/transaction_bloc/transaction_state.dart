// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  final List<String> filterStatus;
  final String sort;
  const TransactionState({
    required this.filterStatus,
    required this.sort,
  });

  @override
  List<Object> get props => [filterStatus, sort];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial({
    required super.filterStatus,
    required super.sort,
  });

  @override
  List<Object> get props => [filterStatus, sort];
}

class TransactionLoading extends TransactionState {
  const TransactionLoading({
    required super.filterStatus,
    required super.sort,
  });

  @override
  List<Object> get props => [filterStatus, sort];
}

class TransactionFailure extends TransactionState {
  final String errorMessage;

  const TransactionFailure({
    required super.filterStatus,
    required super.sort,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [filterStatus, sort, errorMessage];
}

class TransactionSuccess extends TransactionState {
  final List<OrderModel> orders;

  const TransactionSuccess({
    required this.orders,
    required super.filterStatus,
    required super.sort,
  });

  @override
  List<Object> get props => [filterStatus, sort, orders];
}
