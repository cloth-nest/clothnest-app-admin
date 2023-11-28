part of 'add_category_bloc.dart';

abstract class AddCategoryState extends Equatable {
  final List<Category> categories;
  final Category? selectedCategory;

  const AddCategoryState({
    required this.categories,
    this.selectedCategory,
  });

  @override
  List<Object> get props => [categories];
}

class AddCategoryInitial extends AddCategoryState {
  const AddCategoryInitial({
    required super.categories,
    super.selectedCategory,
  });

  @override
  List<Object> get props => [categories];
}

class AddCategorySuccess extends AddCategoryState {
  final Category newCategory;

  const AddCategorySuccess({
    required super.categories,
    required this.newCategory,
    super.selectedCategory,
  });

  @override
  List<Object> get props => [newCategory];
}

class AddCategoryFailure extends AddCategoryState {
  final String errorMessage;

  const AddCategoryFailure({
    required super.categories,
    required this.errorMessage,
    super.selectedCategory,
  });

  @override
  List<Object> get props => [errorMessage];
}

class AddCategoryLoading extends AddCategoryState {
  const AddCategoryLoading({
    required super.categories,
    super.selectedCategory,
  });
}

class AddCategoryChanged extends AddCategoryState {
  const AddCategoryChanged({
    required super.categories,
    super.selectedCategory,
  });

  @override
  List<Object> get props => [selectedCategory!];
}
