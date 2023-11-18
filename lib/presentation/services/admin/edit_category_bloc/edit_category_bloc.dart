import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/repository/category_repository.dart';

part 'edit_category_event.dart';
part 'edit_category_state.dart';

class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {
  late CategoryRepository categoryRepository;

  EditCategoryBloc(this.categoryRepository) : super(EditCategoryInitial()) {
    on<EditCategorySubmitted>(_onSubmitted);
  }

  void _onSubmitted(
      EditCategorySubmitted event, Emitter<EditCategoryState> emit) async {
    emit(EditCategoryLoading());

    try {
      Category newCategory =
          await categoryRepository.editCategory(event.newCategory);
      emit(EditCategorySuccess(newCategory: newCategory));
    } catch (e) {
      emit(EditCategoryFailure(errorMessage: e.toString()));
    }
  }
}
