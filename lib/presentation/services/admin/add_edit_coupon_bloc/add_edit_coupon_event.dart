part of 'add_edit_coupon_bloc.dart';

abstract class AddEditCouponEvent extends Equatable {
  const AddEditCouponEvent();

  @override
  List<Object> get props => [];
}

class ButtonAddCouponPressed extends AddEditCouponEvent {
  final Coupon coupon;
  final File imageFile;

  const ButtonAddCouponPressed({
    required this.coupon,
    required this.imageFile,
  });

  @override
  List<Object> get props => [coupon];
}
