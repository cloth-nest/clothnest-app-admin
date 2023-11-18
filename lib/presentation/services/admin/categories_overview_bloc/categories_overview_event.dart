part of 'categories_overview_bloc.dart';

abstract class CategoriesOverviewEvent extends Equatable {
  const CategoriesOverviewEvent();
}

class CategoriesOverviewFetched extends CategoriesOverviewEvent {
  @override
  List<Object?> get props => [];
}

class NewCategoryAdded extends CategoriesOverviewEvent {
  final Category category;

  const NewCategoryAdded({required this.category});

  @override
  List<Object> get props => [category];
}

class NewCategoryDeleted extends CategoriesOverviewEvent {
  final int idDeleted;

  const NewCategoryDeleted({required this.idDeleted});

  @override
  List<Object> get props => [idDeleted];
}

class NewCategoryEditted extends CategoriesOverviewEvent {
  final Category newCategory;

  const NewCategoryEditted({required this.newCategory});

  @override
  List<Object> get props => [newCategory];
}
