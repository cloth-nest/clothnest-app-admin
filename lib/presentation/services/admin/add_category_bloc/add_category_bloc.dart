import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/repository/category_repository.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  late CategoryRepository categoryRepository;

  List<Category> categories = [];
  Category? selectedCategory;

  AddCategoryBloc(this.categoryRepository)
      : super(const AddCategoryInitial(
          categories: [],
        )) {
    on<CategoryAdded>((event, emit) async {
      emit(AddCategoryLoading(
        categories: categories,
        selectedCategory: selectedCategory,
      ));

      try {
        Category category = Category(
          name: event.nameCategory,
          bgImgUrl: 'urlImage!',
          level: 0,
          id: -1,
        );

        category = await categoryRepository.addCategory(
            event.nameCategory, event.imageFile, event.parentId);

        emit(AddCategorySuccess(
          newCategory: category,
          categories: categories,
          selectedCategory: selectedCategory,
        ));
      } catch (e) {
        emit(AddCategoryFailure(
          errorMessage: e.toString(),
          categories: categories,
          selectedCategory: selectedCategory,
        ));
      }
    });
    on<CategoryInit>(
      (event, emit) async {
        emit(AddCategoryLoading(categories: categories));

        try {
          categories = await categoryRepository.getFirstCategories() ?? [];

          if (categories.isNotEmpty) {
            selectedCategory = categories.first;
          }
          emit(AddCategoryInitial(
            categories: categories,
            selectedCategory: selectedCategory,
          ));
        } catch (e) {
          emit(AddCategoryFailure(
            errorMessage: e.toString(),
            categories: categories,
            selectedCategory: selectedCategory,
          ));
        }
      },
    );
    on<CategoryChanged>(
      (event, emit) {
        selectedCategory = event.selectedCategory;
        emit(AddCategoryChanged(
            categories: categories, selectedCategory: selectedCategory));
      },
    );
  }
}
