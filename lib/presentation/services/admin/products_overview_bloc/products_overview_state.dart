part of 'products_overview_bloc.dart';

abstract class ProductsOverviewState extends Equatable {
  const ProductsOverviewState();

  @override
  List<Object> get props => [];
}

class ProductsOverviewInitial extends ProductsOverviewState {}

class ProductsOverviewLoading extends ProductsOverviewState {}

class ProductsOverviewSuccess extends ProductsOverviewState {
  final ProductDataSourceAsync dataSourceAsync;
  final List<ProductType> productTypes;

  const ProductsOverviewSuccess({
    required this.dataSourceAsync,
    required this.productTypes,
  });

  @override
  List<Object> get props => [dataSourceAsync, productTypes];
}
