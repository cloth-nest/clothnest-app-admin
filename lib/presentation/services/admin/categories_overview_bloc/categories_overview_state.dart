// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'categories_overview_bloc.dart';

abstract class CategoriesOverviewState {
  const CategoriesOverviewState();
}

class CategoriesOverviewLoading extends CategoriesOverviewState {}

class CategoriesOverviewFailure extends CategoriesOverviewState {
  final String errorMessage;

  const CategoriesOverviewFailure({
    required this.errorMessage,
  });
}

class CategoriesOverviewInitial extends CategoriesOverviewState {}

class CategoriesOverviewSuccess extends CategoriesOverviewState {
  final List<Category> categories;
  CategoriesOverviewSuccess({
    required this.categories,
  });
}
