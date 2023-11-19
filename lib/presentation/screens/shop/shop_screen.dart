import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/models/promo.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/category/category_detail_screen.dart';
import 'package:grocery/presentation/screens/checkout/successful_checkout_screen.dart';
import 'package:grocery/presentation/screens/shop/components/box_search.dart';
import 'package:grocery/presentation/screens/shop/components/item_category.dart';
import 'package:grocery/presentation/services/user/shop_bloc/shop_bloc.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController searchController = TextEditingController();
  ShopBloc get _bloc => BlocProvider.of<ShopBloc>(context);

  final List<Promo> promos = [
    Promo(image: AppAssets.promo1),
    Promo(image: AppAssets.promo2),
    Promo(image: AppAssets.promo3),
  ];

  @override
  void initState() {
    super.initState();
    _bloc.add(const ShopCategoriesFetched());
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  navigateToDetailCategory(int idCategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(
          idCategory: idCategory,
        ),
      ),
    );
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
            Padding(
              padding: const EdgeInsets.only(
                left: kPaddingHorizontal,
                right: kPaddingHorizontal,
                top: 65,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: BoxSearch(
                      controller: searchController,
                      hintText: 'Search for products',
                      callback: (keyword) {},
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SuccessfulCheckOutScreen(
                            name: 'Hung',
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      FontAwesomeIcons.bell,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
              ),
              child: Text(
                'What are you looking for?',
                style: AppStyles.bold.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            //list categories
            _categories(size),
            // const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: kPaddingHorizontal,
            //   ),
            //   child: Text(
            //     'Promos for you',
            //     style: AppStyles.bold.copyWith(fontSize: 18),
            //   ),
            // ),
            // const SizedBox(height: 15),
            // // list promos
            // SizedBox(
            //   height: size.height * .15,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       Promo promo = promos[index];
            //       return ItemPromo(promo: promo);
            //     },
            //     itemCount: promos.length,
            //   ),
            // )
          ],
        ),
      )),
    );
  }

  Widget _categories(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingHorizontal,
      ),
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          if (state is ShopLoading) {
            return LoadingScreen().showLoadingWidget();
          } else if (state is ShopFetchCategoriesSuccess) {
            List<Category> categories = state.categories;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1 / 1.3,
                mainAxisSpacing: 5,
                mainAxisExtent: size.width * .28,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                Category category = categories[index];
                return ItemCategory(
                  category: category,
                  onTap: () => navigateToDetailCategory(category.id!),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
