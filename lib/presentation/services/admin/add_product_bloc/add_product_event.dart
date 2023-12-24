// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object> get props => [];
}

class AddProductStarted extends AddProductEvent {
  final int productTypeId;

  const AddProductStarted({
    required this.productTypeId,
  });
}

class AddProductCleared extends AddProductEvent {
  const AddProductCleared();
}

class ProductAdded extends AddProductEvent {
  final int productTypeId;
  final int categoryId;
  final String productName;
  final String productDescription;
  final List<Map<String, dynamic>> attributes;
  const ProductAdded({
    required this.productTypeId,
    required this.categoryId,
    required this.productName,
    required this.productDescription,
    required this.attributes,
  });
}

class ProductEditted extends AddProductEvent {
  final Product? product;
  final List<File> imageFiles;

  const ProductEditted({
    required this.product,
    required this.imageFiles,
  });
}
