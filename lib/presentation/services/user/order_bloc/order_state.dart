part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderFailure extends OrderState {
  final String errorMessage;

  const OrderFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class OrderSuccess extends OrderState {
  final List<Order> orders;

  const OrderSuccess({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrderLoading extends OrderState {}
