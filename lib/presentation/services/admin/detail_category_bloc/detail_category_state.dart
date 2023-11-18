part of 'detail_category_bloc.dart';

abstract class DetailCategoryState extends Equatable {
  const DetailCategoryState();

  @override
  List<Object> get props => [];
}

class DetailCategoryInitial extends DetailCategoryState {
  final Category? category;

  const DetailCategoryInitial({this.category});
}

class DetailCategoryLoading extends DetailCategoryState {}

class FetchProductsLoading extends DetailCategoryState {}

class FetchProductsSuccess extends DetailCategoryState {
  final List<Product> products;

  const FetchProductsSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

class FetchProductsFailure extends DetailCategoryState {
  final String errorMessage;

  const FetchProductsFailure({required this.errorMessage});
}

class DetailCategoryFailure extends DetailCategoryState {
  final String errorMessage;

  const DetailCategoryFailure({required this.errorMessage});
}

class DeleteCategorySuccess extends DetailCategoryState {
  final int idDeleted;

  const DeleteCategorySuccess({required this.idDeleted});
}

class EditCategorySuccess extends DetailCategoryState {
  final Category category;

  const EditCategorySuccess({required this.category});
}
