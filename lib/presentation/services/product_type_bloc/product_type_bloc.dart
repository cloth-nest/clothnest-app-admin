import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/product_type_data_source.dart';
import 'package:grocery/data/models/product_types_data.dart';
import 'package:grocery/data/repository/product_type_repository.dart';

part 'product_type_event.dart';
part 'product_type_state.dart';

class ProductTypeBloc extends Bloc<ProductTypeEvent, ProductTypeState> {
  // resource
  late ProductTypeRepository productTypeRepository;

  // Data
  ProductTypesData? productTypesData;

  ProductTypeBloc(this.productTypeRepository) : super(ProductTypeInitital()) {
    on<ProductTypeStarted>(_onStarted);
    on<ProductTypeAdded>(_onAdded);
    on<ProductAttributeUpdated>(_onUpdated);
  }

  FutureOr<void> _onStarted(
      ProductTypeStarted event, Emitter<ProductTypeState> emit) async {
    emit(ProductTypeLoading());
    try {
      ProductTypesData? productTypesData =
          await productTypeRepository.getProductTypeData();
      ProductTypeDataSourceAsync attributeDataSourceAsync =
          ProductTypeDataSourceAsync(
        productTypesData: productTypesData!,
        context: event.context,
      );
      emit(ProductTypeLoaded(attributeDataSourceAsync, null));
    } catch (e) {
      emit(ProductTypeError(e.toString()));
    }
  }

  FutureOr<void> _onAdded(
      ProductTypeAdded event, Emitter<ProductTypeState> emit) async {
    emit(ProductTypeLoading());
    try {
      await productTypeRepository.addProductType(
        event.productType,
      );
      ProductTypesData? productTypesData =
          await productTypeRepository.getProductTypeData();
      ProductTypeDataSourceAsync attributeDataSourceAsync =
          ProductTypeDataSourceAsync(
        productTypesData: productTypesData!,
        context: event.context,
      );
      emit(ProductTypeLoaded(attributeDataSourceAsync, true));
    } catch (e) {
      emit(ProductTypeError(e.toString()));
    }
  }

  FutureOr<void> _onUpdated(
      ProductAttributeUpdated event, Emitter<ProductTypeState> emit) async {
    try {
      await productTypeRepository.updateProductAttribute(
        event.attribute,
        event.id,
      );
    } catch (e) {
      emit(ProductTypeError(e.toString()));
    }
  }
}
