import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/categories_data_source.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/models/products_data.dart';
import 'package:grocery/data/models/products_data_source_async.dart';
import 'package:grocery/data/repository/category_repository.dart';
import 'package:grocery/data/repository/product_repository.dart';

import '../../../../data/models/categories_data.dart';

part 'edit_category_event.dart';
part 'edit_category_state.dart';

class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {
  late CategoryRepository categoryRepository;
  late ProductRepository productRepository;
  // Data
  CategoriesData? categoriesData;
  ProductsData? productsData;

  EditCategoryBloc(
    this.categoryRepository,
    this.productRepository,
  ) : super(EditCategoryInitial()) {
    on<EditCategorySubmitted>(_onSubmitted);
    on<EditCategoryInit>(_onInit);
  }

  void _onSubmitted(
      EditCategorySubmitted event, Emitter<EditCategoryState> emit) async {
    emit(EditCategoryLoading());

    try {
      await categoryRepository.editCategory(event.newCategory, event.fileImage);
      Category? newCategory =
          await categoryRepository.getOneCategory(event.newCategory.id);
      emit(EditCategorySuccess(newCategory: newCategory!));
    } catch (e) {
      emit(EditCategoryFailure(errorMessage: e.toString()));
    }
  }

  void _onInit(EditCategoryInit event, Emitter<EditCategoryState> emit) async {
    emit(EditCategoryLoading());

    try {
      categoriesData =
          await categoryRepository.getCategories(parentId: event.id);
      productsData = await productRepository.getProductsByIDCategory(event.id);
      ProductDataSourceAsync? productDataSourceAsync = ProductDataSourceAsync(
        productsData: productsData!,
        context: event.context,
      );

      CategoryDataSourceAsync? categoryDataSource = CategoryDataSourceAsync(
        categoriesData: categoriesData!,
        context: event.context,
      );

      emit(EditCategoryLoaded(
        categoryDataSource: categoryDataSource,
        productDataSourceAsync: productDataSourceAsync,
      ));
    } catch (e) {
      emit(EditCategoryFailure(errorMessage: e.toString()));
    }
  }
}
