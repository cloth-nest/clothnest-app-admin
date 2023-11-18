part of 'coupon_bloc.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponFailure extends CouponState {
  final String errorMessage;

  const CouponFailure({
    required this.errorMessage,
  });

  List<Object> get props => [errorMessage];
}

class CouponSuccess extends CouponState {
  final List<Coupon> coupons;

  const CouponSuccess({
    required this.coupons,
  });

  @override
  List<Object> get props => [coupons];
}
