part of 'product_type_bloc.dart';

abstract class ProductTypeState extends Equatable {
  const ProductTypeState();

  @override
  List<Object> get props => [];
}

class ProductTypeInitital extends ProductTypeState {}

class ProductTypeLoading extends ProductTypeState {}

class ProductTypeError extends ProductTypeState {
  final String errorMessage;

  const ProductTypeError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ProductTypeLoaded extends ProductTypeState {
  final ProductTypeDataSourceAsync productTypeDataSourceAsync;
  final bool? isAdded;
  const ProductTypeLoaded(this.productTypeDataSourceAsync, this.isAdded);

  @override
  List<Object> get props => [productTypeDataSourceAsync];
}
