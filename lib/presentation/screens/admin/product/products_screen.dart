// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/product/add_edit_product_screen.dart';
import 'package:grocery/presentation/screens/category/components/item_product.dart';
import 'package:grocery/presentation/services/admin/products_overview_bloc/products_overview_bloc.dart';

class ProductsScreen extends StatefulWidget {
  final List<Product> products;
  final int idCategory;

  const ProductsScreen({
    Key? key,
    required this.products,
    required this.idCategory,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductsOverviewBloc get _bloc =>
      BlocProvider.of<ProductsOverviewBloc>(context);
  Product? newProductAdded;

  @override
  void initState() {
    super.initState();
    _bloc.add(ProductsOverviewStarted(products: widget.products));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: GestureDetector(
          onTap: () {
            if (newProductAdded == null) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop(newProductAdded);
            }
          },
          child: Image.asset(AppAssets.icBack),
        ),
        centerTitle: false,
        title: Text(
          'Products',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.search,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: handleAddProduct,
            child: const Icon(
              Icons.add,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.sort,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: BlocBuilder<ProductsOverviewBloc, ProductsOverviewState>(
        builder: (context, state) {
          if (state is ProductsOverviewSuccess) {
            List<Product> products = state.products;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Product product = products[index];
                        return GestureDetector(
                          onTap: () => {},
                          child: ItemProduct(
                            product: product,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void handleAddProduct() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditProductScreen(
          product: null,
          idCategory: widget.idCategory,
        ),
      ),
    );

    if (result != null) {
      newProductAdded = result[0];
      _bloc.add(NewProductAdded(product: result[0]));
    }
  }
}
