part of 'add_category_bloc.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryAdded extends AddCategoryEvent {
  final String nameCategory;
  final File? imageFile;
  final int? parentId;

  const CategoryAdded({
    required this.nameCategory,
    this.imageFile,
    this.parentId,
  });

  @override
  List<Object> get props => [nameCategory];
}

class CategoryInit extends AddCategoryEvent {}

class CategoryChanged extends AddCategoryEvent {
  final Category selectedCategory;

  const CategoryChanged({required this.selectedCategory});

  @override
  List<Object> get props => [selectedCategory];
}
