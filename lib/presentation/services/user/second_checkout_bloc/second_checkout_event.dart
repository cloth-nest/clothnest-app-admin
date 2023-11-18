// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'second_checkout_bloc.dart';

abstract class SecondCheckoutEvent extends Equatable {
  const SecondCheckoutEvent();

  @override
  List<Object> get props => [];
}

class SecondCheckoutStarted extends SecondCheckoutEvent {}

class CheckoutSubmitted extends SecondCheckoutEvent {
  final Order order;
  final bool isFromCart;
  const CheckoutSubmitted({
    required this.order,
    required this.isFromCart,
  });

  @override
  List<Object> get props => [
        order,
        isFromCart,
      ];
}

class NewAddressChosen extends SecondCheckoutEvent {
  final Address newAddress;

  const NewAddressChosen({required this.newAddress});

  @override
  List<Object> get props => [newAddress];
}

class CouponChecked extends SecondCheckoutEvent {
  final String couponCode;
  final List<Map<String, dynamic>> productList;
  const CouponChecked({
    required this.couponCode,
    required this.productList,
  });
}
