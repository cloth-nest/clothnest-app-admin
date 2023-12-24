import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/repository/product_type_repository.dart';

part 'detail_product_type_event.dart';
part 'detail_product_type_state.dart';

class DetailProductTypeBloc
    extends Bloc<DetailProductTypeEvent, DetailProductTypeState> {
  final ProductTypeRepository productTypeRepository;

  DetailProductTypeBloc(
    this.productTypeRepository,
  ) : super(DetailProductTypeLoading()) {
    on<DetailProductTypeInit>(_onInit);
  }

  FutureOr<void> _onInit(
      DetailProductTypeInit event, Emitter<DetailProductTypeState> emit) async {
    emit(DetailProductTypeLoading());

    try {
      List<ProductType>? productAttributes = await productTypeRepository
          .getAllProductAttributes(productTypeId: event.productTypeId);
      List<ProductType>? variantAttributes = await productTypeRepository
          .getAllVariantAttributes(productTypeId: event.productTypeId);

      emit(
        DetailProductTypeInitial(
          productAttributes: productAttributes ?? [],
          variantAttributes: variantAttributes ?? [],
        ),
      );
    } catch (e) {
      debugPrint('error _onInit: $e');
    }
  }
}
