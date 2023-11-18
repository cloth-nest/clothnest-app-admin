import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/repository/category_repository.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final CategoryRepository _categoryRepository;

  List<Category> categories = [];

  ShopBloc(this._categoryRepository) : super(ShopInitial()) {
    on<ShopCategoriesFetched>(_onFetched);
  }

  void _onFetched(event, emit) async {
    emit(ShopLoading());

    try {
      List<Category>? result = await _categoryRepository.getCategories();
      categories = result!;
      emit(ShopFetchCategoriesSuccess(categories: categories));
    } catch (e) {
      emit(ShopFetchCategoriesFailure(errorMessage: e.toString()));
    }
  }
}
