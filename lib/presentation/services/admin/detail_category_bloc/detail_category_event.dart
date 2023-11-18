part of 'detail_category_bloc.dart';

abstract class DetailCategoryEvent {
  const DetailCategoryEvent();
}

class DeleteCategorySubmitted extends DetailCategoryEvent {
  final int id;
  const DeleteCategorySubmitted({required this.id});
}

class DetailCategoryStarted extends DetailCategoryEvent {
  final Category category;
  const DetailCategoryStarted({required this.category});
}

class ProductsFetched extends DetailCategoryEvent {
  final int idCategory;
  const ProductsFetched({required this.idCategory});
}

class NewCategoryEditted extends DetailCategoryEvent {
  final Category category;
  const NewCategoryEditted({required this.category});
}

class NewProductAdded extends DetailCategoryEvent {
  final Product product;
  const NewProductAdded({required this.product});
}
