import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery/data/models/detail_product.dart';
import 'package:grocery/data/repository/product_repository.dart';

part 'detail_product_event.dart';
part 'detail_product_state.dart';

class DetailProductBloc extends Bloc<DetailProductEvent, DetailProductState> {
  ProductRepository productRepository;

  DetailProductBloc(
    this.productRepository,
  ) : super(DetailProductLoading()) {
    on<DetailProductStarted>(_onStarted);
  }

  FutureOr<void> _onStarted(
      DetailProductStarted event, Emitter<DetailProductState> emit) async {
    try {
      emit(DetailProductLoading());

      DetailProduct? product =
          await productRepository.getProductDetail(event.idProduct);

      emit(DetailProductInitial(product: product!));
    } catch (e) {
      debugPrint('error: $e');
      emit(DetailProductFailure());
    }
  }
}
