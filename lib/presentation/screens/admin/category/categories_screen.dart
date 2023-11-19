import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/category/add_category_screen.dart';
import 'package:grocery/presentation/screens/admin/category/detail_category_screen.dart';
import 'package:grocery/presentation/services/admin/categories_overview_bloc/categories_overview_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController searchController = TextEditingController();
  CategoriesOverviewBloc get _bloc =>
      BlocProvider.of<CategoriesOverviewBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(CategoriesOverviewFetched());
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: AppStyles.semibold,
                    ),
                    GestureDetector(
                      onTap: handleAddCategory,
                      child: Text(
                        'Create category',
                        style: AppStyles.medium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //list categories
              _categories(size),
            ],
          ),
        ),
      ),
    );
  }

  navigateToDetailCategoryScreen(Category category) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailCategoryScreen(category: category),
      ),
    );

    if (result != null) {
      if (result is int) {
        _bloc.add(
          NewCategoryDeleted(idDeleted: result),
        );
      } else {
        _bloc.add(
          NewCategoryEditted(newCategory: result),
        );
      }
    }
  }

  _categories(Size size) {
    return BlocBuilder<CategoriesOverviewBloc, CategoriesOverviewState>(
      builder: (context, state) {
        if (state is CategoriesOverviewLoading) {
          return LoadingScreen().showLoadingWidget();
        } else if (state is CategoriesOverviewFailure) {
          return Text(state.errorMessage);
        } else if (state is CategoriesOverviewSuccess) {
          List<Category> categories = state.categories;
          return ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: _buildCategories(categories),
            ),
          );
          // return Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: kPaddingHorizontal,
          //   ),
          //   child: GridView.builder(
          //     physics: const NeverScrollableScrollPhysics(),
          //     shrinkWrap: true,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 4,
          //       crossAxisSpacing: 8,
          //       mainAxisSpacing: 8,
          //       childAspectRatio: 0.8,
          //     ),
          //     itemCount: categories.length,
          //     itemBuilder: (context, index) {
          //       Category category = categories[index];
          //       return ItemCategory(
          //         category: category,
          //         onTap: () => navigateToDetailCategoryScreen(
          //           category,
          //         ),
          //       );
          //     },
          //   ),
          // );
        }
        return LoadingScreen().showLoadingWidget();
      },
    );
  }

  Widget _buildCategories(List<Category> categories) {
    final categoriesWidget = [];

    return const SizedBox.shrink();
  }

  handleAddCategory() async {
    final Category? newCategory = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddCategoryScreen(),
      ),
    );

    if (newCategory != null) {
      _bloc.add(
        NewCategoryAdded(category: newCategory),
      );
    }
  }
}
