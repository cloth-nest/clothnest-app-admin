// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_edit_product_bloc.dart';

abstract class AddEditProductEvent extends Equatable {
  const AddEditProductEvent();

  @override
  List<Object> get props => [];
}

class AddEditProductStarted extends AddEditProductEvent {
  final Product? product;
  const AddEditProductStarted({
    required this.product,
  });
}

class AddEditProductCleared extends AddEditProductEvent {
  const AddEditProductCleared();
}

class ProductAdded extends AddEditProductEvent {
  final Product? product;
  final List<File> imageFiles;

  const ProductAdded({
    required this.product,
    required this.imageFiles,
  });
}

class ProductEditted extends AddEditProductEvent {
  final Product? product;
  final List<File> imageFiles;

  const ProductEditted({
    required this.product,
    required this.imageFiles,
  });
}
