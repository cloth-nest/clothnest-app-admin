part of 'edit_category_bloc.dart';

abstract class EditCategoryState extends Equatable {
  const EditCategoryState();

  @override
  List<Object> get props => [];
}

class EditCategoryInitial extends EditCategoryState {}

class EditCategoryFailure extends EditCategoryState {
  final String errorMessage;

  const EditCategoryFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class EditCategorySuccess extends EditCategoryState {
  final Category newCategory;

  const EditCategorySuccess({required this.newCategory});

  @override
  List<Object> get props => [newCategory];
}

class EditCategoryLoaded extends EditCategoryState {
  final CategoryDataSourceAsync? categoryDataSource;

  const EditCategoryLoaded({
    required this.categoryDataSource,
  });
}

class EditCategoryLoading extends EditCategoryState {}
