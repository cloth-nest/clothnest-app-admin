import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attributes_data.dart';
import 'package:grocery/data/models/product_attributes_data_source.dart';
import 'package:grocery/data/repository/product_attribute_repository.dart';
import 'package:grocery/presentation/utils/functions.dart';

part 'product_attribute_event.dart';
part 'product_attribute_state.dart';

class ProductAttributeBloc
    extends Bloc<ProductAttributeEvent, ProductAttributeState> {
  // resource
  late ProductAttributeRepository productAttributeRepository;

  // Data
  AttributesData? attributesData;

  ProductAttributeBloc(this.productAttributeRepository)
      : super(ProductAttributeInitital()) {
    on<ProductAttributeStarted>(_onStarted);
    on<ProductAttributeAdded>(_onAdded);
    on<ProductAttributeDeleted>(_onDeleted);
  }

  FutureOr<void> _onStarted(ProductAttributeStarted event,
      Emitter<ProductAttributeState> emit) async {
    emit(ProductAttributeLoading());
    try {
      AttributesData? attributesData =
          await productAttributeRepository.getProductAttributesData();
      ProductAttributeDataSourceAsync attributeDataSourceAsync =
          ProductAttributeDataSourceAsync(
        attributesData: attributesData!,
        context: event.context,
      );
      emit(ProductAttributeLoaded(attributeDataSourceAsync, null, null));
    } catch (e) {
      emit(ProductAttributeError(e.toString()));
    }
  }

  FutureOr<void> _onAdded(
      ProductAttributeAdded event, Emitter<ProductAttributeState> emit) async {
    emit(ProductAttributeLoading());
    try {
      await productAttributeRepository.addProductAttribute(event.attribute);
      AttributesData? attributesData =
          await productAttributeRepository.getProductAttributesData();
      ProductAttributeDataSourceAsync attributeDataSourceAsync =
          ProductAttributeDataSourceAsync(
        attributesData: attributesData!,
        context: event.context,
      );
      emit(ProductAttributeLoaded(attributeDataSourceAsync, true, null));
    } catch (e) {
      emit(ProductAttributeError(e.toString()));
    }
  }

  FutureOr<void> _onDeleted(ProductAttributeDeleted event,
      Emitter<ProductAttributeState> emit) async {
    emit(ProductAttributeLoading());
    try {
      await productAttributeRepository
          .deleteProductAttribute(event.idProductAttribute);
      AttributesData? attributesData =
          await productAttributeRepository.getProductAttributesData();
      ProductAttributeDataSourceAsync attributeDataSourceAsync =
          ProductAttributeDataSourceAsync(
        attributesData: attributesData!,
        context: event.context,
      );
      emit(ProductAttributeLoaded(attributeDataSourceAsync, null, true));
    } catch (e) {
      emit(ProductAttributeError(e.toString()));
      showSnackBar(
        event.context,
        'Product attribute is using',
        const Icon(Icons.error_outline),
      );
    }
  }
}
