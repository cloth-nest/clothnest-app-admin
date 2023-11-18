part of 'add_category_bloc.dart';

abstract class AddCategoryState extends Equatable {
  const AddCategoryState();

  @override
  List<Object> get props => [];
}

class AddCategoryInitial extends AddCategoryState {}

class AddCategorySuccess extends AddCategoryState {
  final Category newCategory;

  const AddCategorySuccess({required this.newCategory});

  @override
  List<Object> get props => [newCategory];
}

class AddCategoryFailure extends AddCategoryState {
  final String errorMessage;

  const AddCategoryFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AddCategoryLoading extends AddCategoryState {}
