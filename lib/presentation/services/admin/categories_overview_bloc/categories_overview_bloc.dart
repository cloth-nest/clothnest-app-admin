import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/repository/category_repository.dart';
import 'package:grocery/data/services/cloudinary_service.dart';

part 'categories_overview_event.dart';
part 'categories_overview_state.dart';

class CategoriesOverviewBloc
    extends Bloc<CategoriesOverviewEvent, CategoriesOverviewState> {
  // resource
  late CategoryRepository categoryRepository;

  // Data
  List<Category> categories = [];

  CategoriesOverviewBloc(this.categoryRepository)
      : super(CategoriesOverviewInitial()) {
    on<CategoriesOverviewFetched>(_onFetched);
    on<NewCategoryAdded>(_onNewAdded);
    on<NewCategoryDeleted>(_onNewDeleted);
    on<NewCategoryEditted>(_onNewEditted);
  }

  void _onFetched(CategoriesOverviewFetched event,
      Emitter<CategoriesOverviewState> emit) async {
    emit(CategoriesOverviewLoading());

    try {
      List<Category> categoryList =
          await categoryRepository.getCategories() ?? [];

      categories = categoryList;

      emit(CategoriesOverviewSuccess(categories: categories));
    } catch (e) {
      emit(CategoriesOverviewFailure(errorMessage: e.toString()));
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String? urlImage =
        await CloudinaryService().uploadImage(imageFile.path, 'categories');
    return urlImage ?? '';
  }

  void _onNewAdded(
      NewCategoryAdded event, Emitter<CategoriesOverviewState> emit) {
    categories.add(event.category);
    emit(CategoriesOverviewSuccess(categories: categories));
  }

  void _onNewDeleted(
      NewCategoryDeleted event, Emitter<CategoriesOverviewState> emit) {
    categories.removeWhere((category) => category.id == event.idDeleted);

    emit(CategoriesOverviewSuccess(categories: categories));
  }

  void _onNewEditted(
      NewCategoryEditted event, Emitter<CategoriesOverviewState> emit) {
    categories.removeWhere((category) => category.id == event.newCategory.id);
    categories.add(event.newCategory);
    emit(CategoriesOverviewSuccess(categories: categories));
    // categories = categories.map((e) {
    //   if(e.id == event.newCategory.id){
    //     return event.newCategory
    //   }
    //   return e
    // })
  }
}
