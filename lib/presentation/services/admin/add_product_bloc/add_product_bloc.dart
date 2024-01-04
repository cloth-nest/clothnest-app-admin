import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attribute_values_data.dart';
import 'package:grocery/data/models/categories_data.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/product_image.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/repository/attribute_value_repository.dart';
import 'package:grocery/data/repository/category_repository.dart';
import 'package:grocery/data/repository/product_repository.dart';
import 'package:grocery/data/repository/product_type_repository.dart';
import 'package:grocery/data/services/cloudinary_service.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;
  final ProductTypeRepository productTypeRepository;
  final AttributeValueRepository attributeValueRepository;

  List<Category> categories = [];
  List<Map<String, dynamic>> productAttributes = [];

  AddProductBloc(
    this.productRepository,
    this.categoryRepository,
    this.productTypeRepository,
    this.attributeValueRepository,
  ) : super(const AddProductLoading(
          categories: [],
          productAttributes: [],
        )) {
    on<AddProductStarted>(_onStarted);
    on<ProductAdded>(_onAdded);
    on<ProductEditted>(_onEditted);
    on<AddProductCleared>(_onCleared);
  }

  void _onStarted(
      AddProductStarted event, Emitter<AddProductState> emit) async {
    emit(AddProductLoading(
      categories: categories,
      productAttributes: productAttributes,
    ));

    try {
      CategoriesData? categoriesData =
          await categoryRepository.getSecondCategories(page: 1, limit: 0);
      categories = categoriesData!.categories;
      List<ProductType>? results = await productTypeRepository
          .getAllProductAttributes(productTypeId: event.productTypeId);

      for (final result in results!) {
        AttributeValuesData? attributeValuesData =
            await attributeValueRepository.getAttributeValuesData(result.id);

        productAttributes.add({
          'productType': result,
          'attributeValues': attributeValuesData!.attributeValues,
        });
      }

      emit(AddProductInitial(
        headerText: '',
        categories: categories,
        productAttributes: productAttributes,
      ));
    } catch (e) {
      emit(AddProductInitial(
        headerText: '',
        categories: categories,
        productAttributes: productAttributes,
      ));
    }
  }

  FutureOr<void> _onAdded(
      ProductAdded event, Emitter<AddProductState> emit) async {
    emit(AddProductLoading(
      categories: categories,
      productAttributes: productAttributes,
    ));

    try {
      await productRepository.addProduct(
        productDescription: event.productDescription,
        productName: event.productName,
        productTypeId: event.productTypeId,
        categoryId: event.categoryId,
        attributes: event.attributes,
      );
      emit(AddProductSuccess(
        categories: categories,
        productAttributes: productAttributes,
      ));
    } catch (e) {
      emit(AddProductFailure(
        errorMessage: e.toString(),
        categories: categories,
        productAttributes: productAttributes,
      ));
    }
  }

  Future<List<String>> uploadImages(List<File> imageFiles) async {
    List<String> urls = [];

    for (var file in imageFiles) {
      String? urlImage =
          await CloudinaryService().uploadImage(file.path, 'products');
      urls.add(urlImage!);
    }
    return urls;
  }

  FutureOr<void> _onEditted(
      ProductEditted event, Emitter<AddProductState> emit) async {
    emit(AddProductLoading(
      categories: categories,
      productAttributes: productAttributes,
    ));

    try {
      late Product product;

      if (event.imageFiles.isNotEmpty) {
        List<String> urls = await uploadImages(event.imageFiles);
        List<ProductImage> productImages = [];

        for (int i = 0; i < urls.length; i++) {
          ProductImage productImage = ProductImage(imgUrl: urls[i], index: i);
          productImages.add(productImage);
        }
        product = event.product!;
      }
      Product result = await productRepository.editProduct(product);
      emit(EditProductSuccess(
        product: result,
        categories: categories,
        productAttributes: productAttributes,
      ));
    } catch (e) {
      emit(AddProductFailure(
        errorMessage: e.toString(),
        categories: categories,
        productAttributes: productAttributes,
      ));
    }
  }

  FutureOr<void> _onCleared(
      AddProductCleared event, Emitter<AddProductState> emit) {
    emit(AddProductInitial(
      headerText: "",
      categories: categories,
      productAttributes: productAttributes,
    ));
  }
}
