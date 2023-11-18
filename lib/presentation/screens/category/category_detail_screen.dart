import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/screens/category/components/item_product.dart';
import 'package:grocery/presentation/screens/category/components/sort_filter.dart';
import 'package:grocery/presentation/screens/products/product_detail_screen.dart';
import 'package:grocery/presentation/screens/shop/components/box_search.dart';
import 'package:grocery/presentation/services/user/category_detail_bloc/category_detail_bloc.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class CategoryDetailScreen extends StatefulWidget {
  final int idCategory;

  const CategoryDetailScreen({
    super.key,
    required this.idCategory,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final TextEditingController searchController = TextEditingController();
  CategoryDetailBloc get _bloc => BlocProvider.of<CategoryDetailBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(CategoryDetailProductsFetched(idCategory: widget.idCategory));
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  navigateToProductDetailScreen(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: BoxSearch(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          controller: searchController,
          hintText: 'Search in this category',
          callback: (keyword) {
            _bloc.add(
              TextSearchChanged(
                idCategory: widget.idCategory,
                keyword: keyword,
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingHorizontal,
        ),
        child: Stack(
          children: [
            _products(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: SortFilter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _products() {
    return BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
      builder: (context, state) {
        if (state is CategoryDetailLoading) {
          return LoadingScreen().showLoadingWidget();
        } else if (state is CategoryDetailSuccess) {
          List<Product> products = state.products;

          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return GestureDetector(
                onTap: () => navigateToProductDetailScreen(product),
                child: ItemProduct(
                  product: product,
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
