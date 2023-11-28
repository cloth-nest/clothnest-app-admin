part of 'edit_category_bloc.dart';

abstract class EditCategoryEvent extends Equatable {
  final BuildContext context;
  const EditCategoryEvent({required this.context});

  @override
  List<Object> get props => [];
}

class EditCategorySubmitted extends EditCategoryEvent {
  final Category newCategory;
  final File? fileImage;

  const EditCategorySubmitted({
    required this.newCategory,
    required super.context,
    this.fileImage,
  });

  @override
  List<Object> get props => [newCategory];
}

class EditCategoryInit extends EditCategoryEvent {
  final int id;

  const EditCategoryInit({
    required this.id,
    required super.context,
  });

  @override
  List<Object> get props => [id];
}
