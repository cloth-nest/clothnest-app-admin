part of 'product_attribute_bloc.dart';

abstract class ProductAttributeState extends Equatable {
  const ProductAttributeState();

  @override
  List<Object> get props => [];
}

class ProductAttributeInitital extends ProductAttributeState {}

class ProductAttributeLoading extends ProductAttributeState {}

class ProductAttributeError extends ProductAttributeState {
  final String errorMessage;

  const ProductAttributeError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ProductAttributeLoaded extends ProductAttributeState {
  final ProductAttributeDataSourceAsync attributesDataSource;
  final bool? isAdded;
  final bool? isDeleted;
  const ProductAttributeLoaded(
    this.attributesDataSource,
    this.isAdded,
    this.isDeleted,
  );

  @override
  List<Object> get props => [attributesDataSource];
}
