import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attribute_values_data.dart';
import 'package:grocery/data/models/detail_product.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/warehouse.dart';
import 'package:grocery/data/repository/attribute_value_repository.dart';
import 'package:grocery/data/repository/product_repository.dart';
import 'package:grocery/data/repository/product_type_repository.dart';
import 'package:grocery/data/repository/warehouse_repository.dart';

part 'add_detail_product_event.dart';
part 'add_detail_product_state.dart';

class AddDetailProductBloc
    extends Bloc<AddDetailProductEvent, AddDetailProductState> {
  final ProductRepository productRepository;
  final ProductTypeRepository productTypeRepository;
  final AttributeValueRepository attributeValueRepository;
  final WarehouseRepository warehouseRepository;

  List<Map<String, dynamic>> productAttributes = [];
  List<Map<String, dynamic>> warehouses = [];

  AddDetailProductBloc(
    this.productRepository,
    this.productTypeRepository,
    this.attributeValueRepository,
    this.warehouseRepository,
  ) : super(const AddDetailProductLoading([], [])) {
    on<AddDetailProductStarted>(_onStarted);
    on<AddDetailProductAdded>(_onAdded);
  }

  FutureOr<void> _onStarted(AddDetailProductStarted event,
      Emitter<AddDetailProductState> emit) async {
    try {
      emit(AddDetailProductLoading(productAttributes, warehouses));

      DetailProduct? product =
          await productRepository.getProductDetail(event.idProduct);

      List<ProductType>? results =
          await productTypeRepository.getAllVariantAttributes(
        productTypeId: product!.productType.id,
      );

      for (final result in results!) {
        AttributeValuesData? attributeValuesData =
            await attributeValueRepository.getAttributeValuesData(result.id);

        productAttributes.add({
          'productType': result,
          'attributeValues': attributeValuesData!.attributeValues,
        });
      }

      List<Warehouse>? resultWarehouses =
          await warehouseRepository.getWarehouses();

      for (final result in resultWarehouses!) {
        warehouses.add({
          'warehouse': result.name,
          'idWarehouse': result.id,
        });
      }

      emit(AddDetailProductInitial(
        productAttributes,
        warehouses,
        product: product,
      ));
    } catch (e) {
      debugPrint('error on started: $e');
    }
  }

  FutureOr<void> _onAdded(
      AddDetailProductAdded event, Emitter<AddDetailProductState> emit) async {
    try {
      emit(AddDetailProductLoading(productAttributes, warehouses));

      List<int> imageIds = await productRepository.createBulkImages(
          event.idProduct, event.files);

      final List<Map<String, dynamic>> selectedAttributeValues = [];
      final List<Map<String, dynamic>> selectedWarehouses = [];

      for (var element in event.selectedAttributeValues ?? []) {
        selectedAttributeValues.add({
          'id': element['id'],
          'valueId': element['valueId'],
        });
      }
      for (var element in event.selectedWarehouses ?? []) {
        selectedWarehouses.add({
          'warehouseId': element['idWarehouse'],
          'quantity': element['quantity'] == null
              ? 0
              : int.tryParse(element['quantity']),
        });
      }

      await productRepository.createProductVariant(
        idProduct: event.idProduct,
        variantName: event.variantName,
        price: event.price,
        imageIds: imageIds,
        selectedAttributeValues: selectedAttributeValues,
        selectedWarehouses: selectedWarehouses,
        weight: event.weight,
        sku: event.sku,
      );

      emit(AddDetailProductSuccess(productAttributes, warehouses));
    } catch (e) {
      debugPrint('error on started: $e');
      emit(AddDetailProductFailure(productAttributes, warehouses));
    }
  }
}
