part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionStarted extends TransactionEvent {}

class TransactionSorted extends TransactionEvent {
  final String sortValue;

  const TransactionSorted({required this.sortValue});

  @override
  List<Object> get props => [sortValue];
}

class TransactionFiltered extends TransactionEvent {
  final List<String> filterValues;

  const TransactionFiltered({required this.filterValues});

  @override
  List<Object> get props => [filterValues];
}

class TransactionEditted extends TransactionEvent {
  final Transaction newTransaction;

  const TransactionEditted({
    required this.newTransaction,
  });

  @override
  List<Object> get props => [newTransaction];
}
