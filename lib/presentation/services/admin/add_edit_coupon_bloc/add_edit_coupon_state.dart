part of 'add_edit_coupon_bloc.dart';

abstract class AddEditCouponState extends Equatable {
  const AddEditCouponState();

  @override
  List<Object> get props => [];
}

class AddEditCouponInitial extends AddEditCouponState {}

class AddEditCouponLoading extends AddEditCouponState {}

class AddEditCouponFailure extends AddEditCouponState {
  final String errorMessage;

  const AddEditCouponFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AddEditCouponSuccess extends AddEditCouponState {}
