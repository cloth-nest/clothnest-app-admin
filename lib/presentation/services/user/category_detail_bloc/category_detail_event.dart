part of 'category_detail_bloc.dart';

abstract class CategoryDetailEvent extends Equatable {
  const CategoryDetailEvent();

  @override
  List<Object> get props => [];
}

class CategoryDetailProductsFetched extends CategoryDetailEvent {
  final int idCategory;

  const CategoryDetailProductsFetched({required this.idCategory});

  @override
  List<Object> get props => [idCategory];
}

class CategoryDetailProductsSorted extends CategoryDetailEvent {
  final String type;

  const CategoryDetailProductsSorted({required this.type});

  @override
  List<Object> get props => [type];
}

class CategoryDetailProductsFiltered extends CategoryDetailEvent {
  final int min;
  final int max;

  const CategoryDetailProductsFiltered({
    required this.min,
    required this.max,
  });

  @override
  List<Object> get props => [min, max];
}

class TextSearchChanged extends CategoryDetailEvent {
  final int idCategory;
  final String keyword;

  const TextSearchChanged({
    required this.idCategory,
    required this.keyword,
  });

  @override
  List<Object> get props => [idCategory, keyword];
}
