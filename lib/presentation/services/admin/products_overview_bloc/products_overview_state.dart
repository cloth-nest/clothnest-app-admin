part of 'products_overview_bloc.dart';

abstract class ProductsOverviewState extends Equatable {
  const ProductsOverviewState();

  @override
  List<Object> get props => [];
}

class ProductsOverviewInitial extends ProductsOverviewState {}

class ProductsOverviewLoading extends ProductsOverviewState {}

class ProductsOverviewSuccess extends ProductsOverviewState {
  final List<Product> products;

  const ProductsOverviewSuccess({required this.products});

  @override
  List<Object> get props => [products];
}
