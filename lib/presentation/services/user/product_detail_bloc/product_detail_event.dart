part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailLoved extends ProductDetailEvent {}

class ProductDetailStarted extends ProductDetailEvent {
  final String idProduct;
  final int originalPrice;
  final int discountPrice;

  const ProductDetailStarted({
    required this.idProduct,
    required this.originalPrice,
    required this.discountPrice,
  });

  @override
  List<Object> get props => [idProduct];
}

class ProductDetailChecked extends ProductDetailEvent {
  final String idProduct;
  final int quantity;
  const ProductDetailChecked({
    required this.idProduct,
    required this.quantity,
  });

  @override
  List<Object> get props => [];
}

class ProductDetailAdded extends ProductDetailEvent {
  final String idProduct;

  const ProductDetailAdded({
    required this.idProduct,
  });

  @override
  List<Object> get props => [idProduct];
}

class ProductDetailRemoved extends ProductDetailEvent {
  final String idProduct;

  const ProductDetailRemoved({
    required this.idProduct,
  });

  @override
  List<Object> get props => [idProduct];
}

class ProductAddedToCart extends ProductDetailEvent {
  final String idProduct;
  final int quantity;

  const ProductAddedToCart({
    required this.idProduct,
    required this.quantity,
  });

  @override
  List<Object> get props => [idProduct, quantity];
}
