part of 'category_detail_bloc.dart';

abstract class CategoryDetailState extends Equatable {
  final String sort;
  final int min;
  final int max;

  const CategoryDetailState({
    required this.sort,
    required this.min,
    required this.max,
  });

  @override
  List<Object> get props => [sort, min, max];
}

class CategoryDetailInitial extends CategoryDetailState {
  const CategoryDetailInitial(
      {required super.sort, required super.min, required super.max});
}

class CategoryDetailLoading extends CategoryDetailState {
  const CategoryDetailLoading(
      {required super.sort, required super.min, required super.max});
}

class CategoryDetailFailure extends CategoryDetailState {
  final String errorMessage;

  const CategoryDetailFailure({
    required super.sort,
    required super.min,
    required super.max,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class CategoryDetailSuccess extends CategoryDetailState {
  final List<Product> products;

  const CategoryDetailSuccess({
    required super.sort,
    required super.min,
    required super.max,
    required this.products,
  });

  @override
  List<Object> get props => [products];
}
