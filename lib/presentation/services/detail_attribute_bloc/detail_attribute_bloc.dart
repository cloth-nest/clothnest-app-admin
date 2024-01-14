import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attribute_values_data.dart';
import 'package:grocery/data/models/attribute_values_data_source.dart';
import 'package:grocery/data/models/attributes_data.dart';
import 'package:grocery/data/repository/attribute_value_repository.dart';
import 'package:grocery/presentation/utils/functions.dart';

part 'detail_attribute_event.dart';
part 'detail_attribute_state.dart';

class DetailAttributeBloc
    extends Bloc<DetailAttributeEvent, DetailAttributeState> {
  // resource
  late AttributeValueRepository attributeValueRepository;

  // Data
  AttributesData? attributesData;

  DetailAttributeBloc(this.attributeValueRepository)
      : super(DetailAttributeInitital()) {
    on<DetailAttributeStarted>(_onStarted);
    on<DetailAttributeAdded>(_onAdded);
    on<ProductAttributeUpdated>(_onUpdated);
    on<DetailAttributeDeleted>(_onDeleted);
    on<DetailAttributeUpdated>(_onAttributeUpdated);
  }

  int idProductAttribute = 0;

  FutureOr<void> _onStarted(
      DetailAttributeStarted event, Emitter<DetailAttributeState> emit) async {
    emit(DetailAttributeLoading());
    try {
      idProductAttribute = event.id;

      AttributeValuesData? attributesData =
          await attributeValueRepository.getAttributeValuesData(event.id);
      AttributeValueDataSourceAsync attributeDataSourceAsync =
          AttributeValueDataSourceAsync(
        attributesData: attributesData!,
        context: event.context,
        idProductAttribute: idProductAttribute,
      );
      emit(DetailAttributeLoaded(attributeDataSourceAsync, null));
    } catch (e) {
      emit(DetailAttributeError(e.toString()));
    }
  }

  FutureOr<void> _onAdded(
      DetailAttributeAdded event, Emitter<DetailAttributeState> emit) async {
    emit(DetailAttributeLoading());
    try {
      await attributeValueRepository.addAttributeValue(
        event.attribute,
        event.id,
      );
      AttributeValuesData? attributesData =
          await attributeValueRepository.getAttributeValuesData(event.id);
      AttributeValueDataSourceAsync attributeDataSourceAsync =
          AttributeValueDataSourceAsync(
        attributesData: attributesData!,
        context: event.context,
        idProductAttribute: idProductAttribute,
      );
      emit(DetailAttributeLoaded(attributeDataSourceAsync, true));
    } catch (e) {
      emit(DetailAttributeError(e.toString()));
    }
  }

  FutureOr<void> _onUpdated(
      ProductAttributeUpdated event, Emitter<DetailAttributeState> emit) async {
    try {
      await attributeValueRepository.updateProductAttribute(
        event.attribute,
        event.id,
      );
    } catch (e) {
      emit(DetailAttributeError(e.toString()));
    }
  }

  FutureOr<void> _onDeleted(
      DetailAttributeDeleted event, Emitter<DetailAttributeState> emit) async {
    try {
      emit(DetailAttributeLoading());

      await attributeValueRepository.deleteProductAttribute(
        event.id,
      );

      AttributeValuesData? attributesData = await attributeValueRepository
          .getAttributeValuesData(idProductAttribute);
      AttributeValueDataSourceAsync attributeDataSourceAsync =
          AttributeValueDataSourceAsync(
        attributesData: attributesData!,
        context: event.context,
        idProductAttribute: idProductAttribute,
      );
      emit(DetailAttributeLoaded(attributeDataSourceAsync, null));
    } catch (e) {
      emit(DetailAttributeError(e.toString()));
      showSnackBar(
        event.context,
        'Attribute value is using',
        const Icon(Icons.error_outline),
      );
    }
  }

  FutureOr<void> _onAttributeUpdated(
      DetailAttributeUpdated event, Emitter<DetailAttributeState> emit) async {
    try {
      emit(DetailAttributeLoading());

      await attributeValueRepository.updateAttributeValue(
        event.attribute,
        event.id,
      );

      AttributeValuesData? attributesData = await attributeValueRepository
          .getAttributeValuesData(idProductAttribute);
      AttributeValueDataSourceAsync attributeDataSourceAsync =
          AttributeValueDataSourceAsync(
        attributesData: attributesData!,
        context: event.context,
        idProductAttribute: idProductAttribute,
      );
      emit(DetailAttributeLoaded(attributeDataSourceAsync, null));
    } catch (e) {
      emit(DetailAttributeError(e.toString()));
      showSnackBar(
        event.context,
        'Attribute value is using',
        const Icon(Icons.error_outline),
      );
    }
  }
}
