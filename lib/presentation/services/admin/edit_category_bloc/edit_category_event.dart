part of 'edit_category_bloc.dart';

abstract class EditCategoryEvent extends Equatable {
  const EditCategoryEvent();

  @override
  List<Object> get props => [];
}

class EditCategorySubmitted extends EditCategoryEvent {
  final Category newCategory;

  const EditCategorySubmitted({
    required this.newCategory,
  });

  @override
  List<Object> get props => [newCategory];
}
