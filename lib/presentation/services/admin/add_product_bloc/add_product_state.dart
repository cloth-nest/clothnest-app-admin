// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_bloc.dart';

abstract class AddProductState extends Equatable {
  final List<Category> categories;
  final List<Map<String, dynamic>> productAttributes;

  const AddProductState({
    required this.categories,
    required this.productAttributes,
  });

  @override
  List<Object> get props => [];
}

class AddProductInitial extends AddProductState {
  final Product? product;
  final String headerText;

  const AddProductInitial({
    this.product,
    required this.headerText,
    required super.categories,
    required super.productAttributes,
  });

  @override
  List<Object> get props => [headerText];
}

class AddProductLoading extends AddProductState {
  const AddProductLoading({
    required super.categories,
    required super.productAttributes,
  });
}

class AddProductSuccess extends AddProductState {
  const AddProductSuccess({
    required super.categories,
    required super.productAttributes,
  });
}

class AddProductFailure extends AddProductState {
  final String errorMessage;

  const AddProductFailure({
    required this.errorMessage,
    required super.categories,
    required super.productAttributes,
  });
}

class EditProductSuccess extends AddProductState {
  final Product product;

  const EditProductSuccess({
    required this.product,
    required super.categories,
    required super.productAttributes,
  });
}
