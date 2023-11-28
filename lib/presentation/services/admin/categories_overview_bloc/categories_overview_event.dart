part of 'categories_overview_bloc.dart';

abstract class CategoriesOverviewEvent extends Equatable {
  final BuildContext context;
  const CategoriesOverviewEvent({required this.context});
}

class CategoriesOverviewFetched extends CategoriesOverviewEvent {
  CategoriesOverviewFetched({required super.context});

  @override
  List<Object?> get props => [];
}

class NewCategoryAdded extends CategoriesOverviewEvent {
  final Category category;

  const NewCategoryAdded({required this.category, required super.context});

  @override
  List<Object> get props => [category];
}

class NewCategoryDeleted extends CategoriesOverviewEvent {
  final int idDeleted;

  const NewCategoryDeleted({required this.idDeleted, required super.context});

  @override
  List<Object> get props => [idDeleted];
}

class NewCategoryEditted extends CategoriesOverviewEvent {
  final Category newCategory;

  const NewCategoryEditted({required this.newCategory, required super.context});

  @override
  List<Object> get props => [newCategory];
}

class CategoriesPageChanged extends CategoriesOverviewEvent {
  final int page;
  final int limit;

  const CategoriesPageChanged(
      {required this.page, required this.limit, required super.context});

  @override
  List<Object> get props => [page, limit];
}
