import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/repository/category_repository.dart';
import 'package:grocery/data/services/cloudinary_service.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  late CategoryRepository categoryRepository;

  AddCategoryBloc(this.categoryRepository) : super(AddCategoryInitial()) {
    on<CategoryAdded>((event, emit) async {
      emit(AddCategoryLoading());

      try {
        String? urlImage = await CloudinaryService()
            .uploadImage(event.imageFile.path, 'categories');

        Category category =
            Category(name: event.nameCategory, image: urlImage!, level: 0);

        category = await categoryRepository.addCategory(category);

        emit(AddCategorySuccess(newCategory: category));
      } catch (e) {
        emit(AddCategoryFailure(errorMessage: e.toString()));
      }
    });
  }
}
