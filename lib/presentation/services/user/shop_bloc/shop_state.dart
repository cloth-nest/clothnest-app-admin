part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopFetchCategoriesSuccess extends ShopState {
  final List<Category> categories;

  const ShopFetchCategoriesSuccess({required this.categories});

  @override
  List<Object> get props => [categories];
}

class ShopFetchCategoriesFailure extends ShopState {
  final String errorMessage;

  const ShopFetchCategoriesFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
