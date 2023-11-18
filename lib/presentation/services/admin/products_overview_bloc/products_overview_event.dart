part of 'products_overview_bloc.dart';

abstract class ProductsOverviewEvent extends Equatable {
  const ProductsOverviewEvent();
}

class ProductsOverviewStarted extends ProductsOverviewEvent {
  final List<Product> products;

  const ProductsOverviewStarted({required this.products});

  @override
  List<Object> get props => [products];
}

class NewProductAdded extends ProductsOverviewEvent {
  final Product product;

  const NewProductAdded({required this.product});

  @override
  List<Object> get props => [product];
}

class NewProductEditted extends ProductsOverviewEvent {
  final Product newProduct;

  const NewProductEditted({required this.newProduct});

  @override
  List<Object> get props => [newProduct];
}
