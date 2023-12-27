import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attribute.dart';
import 'package:grocery/data/models/attributes_data.dart';
import 'package:grocery/data/repository/product_attribute_repository.dart';

part 'assign_attributes_event.dart';
part 'assign_attributes_state.dart';

class AssignAttributesBloc
    extends Bloc<AssignAttributesEvent, AssignAttributesState> {
  final ProductAttributeRepository productAttributeRepository;

  AssignAttributesBloc(this.productAttributeRepository)
      : super(AssignAttributesLoading()) {
    on<AssignAttributeInit>(_onInit);
  }

  FutureOr<void> _onInit(
      AssignAttributeInit event, Emitter<AssignAttributesState> emit) async {
    emit(AssignAttributesLoading());

    try {
      AttributesData? attributeData =
          await productAttributeRepository.getProductAttributesData();

      emit(
          AssignAttributesInitial(attributes: attributeData?.attributes ?? []));
    } catch (e) {
      debugPrint('##error init: $e');
    }
  }
}
