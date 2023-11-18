part of 'transaction_detail_bloc.dart';

abstract class TransactionDetailState extends Equatable {
  const TransactionDetailState();

  @override
  List<Object> get props => [];
}

class TransactionDetailInitial extends TransactionDetailState {}

class TransactionDetailLoading extends TransactionDetailState {}

class TransactionDetailFailure extends TransactionDetailState {
  final String errorMessage;

  const TransactionDetailFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class TransactionDetailSuccess extends TransactionDetailState {
  const TransactionDetailSuccess();

  @override
  List<Object> get props => [];
}
