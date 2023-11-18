part of 'add_category_bloc.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryAdded extends AddCategoryEvent {
  final String nameCategory;
  final File imageFile;

  const CategoryAdded({
    required this.nameCategory,
    required this.imageFile,
  });

  @override
  List<Object> get props => [nameCategory, imageFile];
}
