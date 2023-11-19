import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/category/components/detele_category_dialog.dart';
import 'package:grocery/presentation/screens/admin/category/edit_category_screen.dart';
import 'package:grocery/presentation/screens/admin/product/add_edit_product_screen.dart';
import 'package:grocery/presentation/screens/admin/product/products_screen.dart';
import 'package:grocery/presentation/screens/category/components/item_product.dart';
import 'package:grocery/presentation/services/admin/detail_category_bloc/detail_category_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class DetailCategoryScreen extends StatefulWidget {
  final Category category;

  const DetailCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  late String urlImage;
  late String name;

  DetailCategoryBloc get _bloc => BlocProvider.of<DetailCategoryBloc>(context);

  @override
  void initState() {
    super.initState();

    nameController.text = widget.category.name;
    urlImage = widget.category.image ?? '';
    name = widget.category.name;

    _bloc.add(DetailCategoryStarted(category: widget.category));

    _bloc.add(ProductsFetched(idCategory: widget.category.id!));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<DetailCategoryBloc, DetailCategoryState>(
      listener: (context, state) {
        if (state is DetailCategoryLoading) {
          LoadingScreen().show(context: context);
        } else if (state is DeleteCategorySuccess) {
          LoadingScreen().hide();
          Navigator.of(context).pop(state.idDeleted);
          showSnackBar(
            context,
            'Delete successfully',
            const Icon(
              Icons.check,
            ),
          );
        } else if (state is DetailCategoryFailure) {
          LoadingScreen().hide();
          showSnackBar(
            context,
            state.errorMessage,
            const Icon(
              Icons.error_outline,
            ),
          );
        }
      },
      builder: (context, state) {
        Category? newCategory;

        if (state is EditCategorySuccess) {
          nameController.text = state.category.name;
          urlImage = state.category.image ?? '';
          name = state.category.name;
          newCategory = state.category;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(newCategory),
              child: Image.asset(AppAssets.icBack),
            ),
            elevation: 0.3,
            centerTitle: true,
            title: Text(
              name,
              style: AppStyles.bold.copyWith(
                fontSize: 19,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: navigateToEditCategoryScreen,
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    FontAwesomeIcons.penToSquare,
                    size: 20,
                    color: AppColors.text,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => deleteCategory(context),
                child: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    FontAwesomeIcons.trashCan,
                    size: 20,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextFieldInput(
                      isEnabled: false,
                      hintText: 'Name Category',
                      controller: nameController,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Display Image',
                      style: AppStyles.medium.copyWith(),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.network(
                          urlImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._products(state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _products(DetailCategoryState state) {
    if (state is FetchProductsLoading) {
      return [LoadingScreen().showLoadingWidget()];
    } else if (state is FetchProductsSuccess) {
      List<Product> products = state.products;

      return [
        Row(
          children: [
            Text(
              'Products',
              style: AppStyles.medium.copyWith(),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductsScreen(
                      products: products,
                      idCategory: widget.category.id!,
                    ),
                  ),
                );
                if (result != null) {
                  _bloc.add(NewProductAdded(product: result));
                }
              },
              child: Image.asset(AppAssets.icArrowRight),
            )
          ],
        ),
        Expanded(
          child: GridView.builder(
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddEditProductScreen(
                        product: product,
                        idCategory: widget.category.id!,
                      ),
                    ),
                  );
                },
                child: ItemProduct(
                  product: product,
                ),
              );
            },
          ),
        ),
      ];
    }
    return [];
  }

  deleteCategory(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) {
        return DeleteCategoryDialog(
          category: widget.category,
        );
      },
    );
  }

  void navigateToEditCategoryScreen() async {
    Category? category = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditCategoryScreen(
          category: widget.category,
        ),
      ),
    );

    if (category != null) {
      _bloc.add(NewCategoryEditted(category: category));
    }
  }
}
