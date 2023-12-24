part of 'products_overview_bloc.dart';

abstract class ProductsOverviewEvent extends Equatable {
  const ProductsOverviewEvent();
}

class ProductsOverviewStarted extends ProductsOverviewEvent {
  final BuildContext context;

  const ProductsOverviewStarted({
    required this.context,
  });

  @override
  List<Object> get props => [];
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
