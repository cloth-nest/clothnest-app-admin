import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/coupon.dart';
import 'package:grocery/data/repository/coupon_repository.dart';
import 'package:grocery/data/services/cloudinary_service.dart';

part 'add_edit_coupon_event.dart';
part 'add_edit_coupon_state.dart';

class AddEditCouponBloc extends Bloc<AddEditCouponEvent, AddEditCouponState> {
  final CouponRepository _couponRepository;

  AddEditCouponBloc(this._couponRepository) : super(AddEditCouponInitial()) {
    on<ButtonAddCouponPressed>(_onAdded);
  }

  FutureOr<void> _onAdded(
      ButtonAddCouponPressed event, Emitter<AddEditCouponState> emit) async {
    emit(AddEditCouponLoading());

    try {
      String? urlImage = await CloudinaryService()
          .uploadImage(event.imageFile.path, 'coupons');
      Coupon coupon = event.coupon.copyWith(thumbnail: urlImage!);
      await _couponRepository.addCoupon(coupon);
      emit(AddEditCouponSuccess());
    } catch (e) {
      emit(AddEditCouponFailure(errorMessage: e.toString()));
    }
  }
}
