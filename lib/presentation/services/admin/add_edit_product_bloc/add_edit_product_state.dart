// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_edit_product_bloc.dart';

abstract class AddEditProductState extends Equatable {
  const AddEditProductState();

  @override
  List<Object> get props => [];
}

class AddEditProductInitial extends AddEditProductState {
  final Product? product;
  final String headerText;

  const AddEditProductInitial({
    this.product,
    required this.headerText,
  });

  @override
  List<Object> get props => [headerText];
}

class AddEditProductLoading extends AddEditProductState {}

class AddProductSuccess extends AddEditProductState {
  final Product product;

  const AddProductSuccess({required this.product});
}

class AddEditProductFailure extends AddEditProductState {
  final String errorMessage;

  const AddEditProductFailure({required this.errorMessage});
}

class EditProductSuccess extends AddEditProductState {
  final Product product;

  const EditProductSuccess({required this.product});
}
