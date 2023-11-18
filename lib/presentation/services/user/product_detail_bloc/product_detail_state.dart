part of 'product_detail_bloc.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailFailure extends ProductDetailState {
  final String errorMessage;

  const ProductDetailFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ProductDetailCheckedSuccess extends ProductDetailState {
  final double totalPrice;
  final int quantity;

  const ProductDetailCheckedSuccess({
    required this.totalPrice,
    required this.quantity,
  });
}

class ProductDetailCheckedFailure extends ProductDetailState {
  const ProductDetailCheckedFailure();
}

class ProductDetailLoaded extends ProductDetailState {
  final int quantity;
  final double price;
  final int totalQuantity;
  final num rating;
  final List<Comment> comments;
  final int? isCheckInventory;

  const ProductDetailLoaded({
    required this.quantity,
    required this.price,
    required this.totalQuantity,
    required this.comments,
    required this.rating,
    this.isCheckInventory = 2,
  });

  @override
  List<Object> get props => [
        quantity,
        price,
        totalQuantity,
        rating,
        comments,
        isCheckInventory!,
      ];
}
