import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attribute.dart';
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
    on<ProductAttributesAdded>(_onProductAttributesAdded);
    on<VariantAttributesAdded>(_onVariantAttributesAdded);
    on<AttributeRemoved>(_onRemoved);
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

  FutureOr<void> _onProductAttributesAdded(ProductAttributesAdded event,
      Emitter<DetailProductTypeState> emit) async {
    emit(DetailProductTypeLoading());

    try {
      await productTypeRepository.addAttribute(
        productTypeId: event.productTypeId,
        attributeType: 'PRODUCT_ATTRIBUTE',
        productAttributeIds: event.attributes.map((e) => e.id).toList(),
      );
      emit(DetailProductTypeAdded());
    } catch (e) {
      debugPrint('##error _onProductAttributesAdded: $e');
    }
  }

  FutureOr<void> _onVariantAttributesAdded(VariantAttributesAdded event,
      Emitter<DetailProductTypeState> emit) async {
    emit(DetailProductTypeLoading());

    try {
      await productTypeRepository.addAttribute(
        productTypeId: event.productTypeId,
        attributeType: 'VARIANT_ATTRIBUTE',
        productAttributeIds: event.attributes.map((e) => e.id).toList(),
      );

      emit(DetailProductTypeAdded());
    } catch (e) {
      debugPrint('##error _onVariantAttributesAdded: $e');
    }
  }

  FutureOr<void> _onRemoved(
      AttributeRemoved event, Emitter<DetailProductTypeState> emit) async {
    emit(DetailProductTypeLoading());

    try {
      await productTypeRepository.removeAttribute(
        event.productTypeId,
        event.attributeType,
        event.productAttributeIds,
      );

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
      debugPrint('##error _onVariantAttributesAdded: $e');
    }
  }
}
