import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/product_types_data.dart';
import 'package:grocery/data/models/products_data.dart';
import 'package:grocery/data/models/products_data_source_async.dart';
import 'package:grocery/data/repository/product_repository.dart';
import 'package:grocery/data/repository/product_type_repository.dart';

part 'products_overview_event.dart';
part 'products_overview_state.dart';

class ProductsOverviewBloc
    extends Bloc<ProductsOverviewEvent, ProductsOverviewState> {
  late ProductRepository _productRepository;
  late ProductTypeRepository _productTypeRepository;

  ProductsOverviewBloc(
    this._productRepository,
    this._productTypeRepository,
  ) : super(ProductsOverviewInitial()) {
    on<ProductsOverviewStarted>(_onStarted);
    on<NewProductAdded>(_onNewAdded);
    on<NewProductEditted>(_onNewEditted);
  }

  FutureOr<void> _onNewAdded(event, emit) {
    //emit(ProductsOverviewSuccess(products: [...products, event.product]));
  }

  FutureOr<void> _onStarted(event, emit) async {
    emit(ProductsOverviewLoading());

    try {
      ProductsData? data = await _productRepository.getProducts();
      ProductTypesData? productTypesData =
          await _productTypeRepository.getProductTypeData(limit: 0, page: 1);

      List<ProductType> productTypes = productTypesData!.productTypes;

      emit(ProductsOverviewSuccess(
        dataSourceAsync: ProductDataSourceAsync(
          productsData: data!,
          context: event.context,
        ),
        productTypes: productTypes,
      ));
    } catch (e) {
      debugPrint('error started: $e');
    }
  }

  FutureOr<void> _onNewEditted(
      NewProductEditted event, Emitter<ProductsOverviewState> emit) {
    // products.removeWhere((product) => product.id == event.newProduct.id);
    // products.add(event.newProduct);
    // emit(ProductsOverviewSuccess(products: products));
  }
}
