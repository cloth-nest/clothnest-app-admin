part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {}

class CartAdded extends CartEvent {
  final Cart cart;

  const CartAdded({
    required this.cart,
  });

  @override
  List<Object> get props => [cart];
}

class CartRemoved extends CartEvent {
  final Cart cart;

  const CartRemoved({
    required this.cart,
  });

  @override
  List<Object> get props => [cart];
}
