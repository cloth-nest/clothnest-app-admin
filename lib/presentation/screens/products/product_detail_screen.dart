import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery/data/models/cart.dart';
import 'package:grocery/data/models/comment.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/checkout/first_checkout_screen.dart';
import 'package:grocery/presentation/screens/products/components/box_add_to_cart.dart';
import 'package:grocery/presentation/screens/products/components/box_cart.dart';
import 'package:grocery/presentation/screens/review/review_screen.dart';
import 'package:grocery/presentation/services/user/product_detail_bloc/product_detail_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/edit_product_cart.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CarouselController controller = CarouselController();
  int currentIndex = 0;
  ProductDetailBloc get _bloc => BlocProvider.of<ProductDetailBloc>(context);

  final List<Product> productSuggestions = [];

  @override
  void initState() {
    super.initState();
    // _bloc.add(ProductDetailStarted(
    //   idProduct: widget.product.id!,
    //   discountPrice: widget.product.discount,
    //   originalPrice: widget.product.price,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(
        actions: [
          Icon(
            Icons.favorite_outline_outlined,
            color: AppColors.primary,
          ),
          SizedBox(width: 20),
          Icon(
            Icons.share,
            color: AppColors.primary,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: BlocListener<ProductDetailBloc, ProductDetailState>(
        listener: (context, state) {
          if (state is ProductDetailLoaded) {
            double totalPrice = state.quantity.toDouble() * state.price;

            if (state.isCheckInventory != 2) {
              if (state.isCheckInventory == 1) {
                navigateToReviewOrderScreen(totalPrice, state.quantity);
              } else {
                showSnackBar(
                  context,
                  'The product is not available',
                  const Icon(Icons.error),
                );
              }
            }
          }
        },
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            // list images
            listImages(),
            // name
            Padding(
              padding: const EdgeInsets.only(
                left: kPaddingHorizontal,
                top: 15,
              ),
              child: Text(
                'widget.product.productName',
                style: AppStyles.bold.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
            // unit
            Padding(
              padding: const EdgeInsets.only(left: kPaddingHorizontal),
              child: Text(
                'widget.product.unit',
                style: AppStyles.regular.copyWith(
                  color: AppColors.gray,
                  fontSize: 16,
                ),
              ),
            ),
            // original price
            // if (widget.product.discount != 0)
            //   Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            //     child: Text(
            //       '\$${widget.product.price}',
            //       style: AppStyles.regular.copyWith(
            //         fontSize: 15,
            //         decoration: TextDecoration.lineThrough,
            //         color: AppColors.text,
            //       ),
            //     ),
            //   ),
            const SizedBox(height: 10),
            // price
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            //   child: Row(
            //     children: [
            //       widget.product.discount == 0
            //           ? Text(
            //               '\$${widget.product.price}',
            //               style: AppStyles.medium.copyWith(
            //                 color: AppColors.secondary,
            //               ),
            //             )
            //           : Text(
            //               '\$${widget.product.price * (100 - widget.product.discount) * 0.01}',
            //               style: AppStyles.medium.copyWith(
            //                 color: AppColors.secondary,
            //               ),
            //             ),
            //       const Spacer(),
            //       EditProductCart(
            //         idProduct: widget.product.id!,
            //       ),
            //     ],
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
                vertical: 5,
              ),
              child: Divider(
                color: AppColors.gray,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
              ),
              child: Text(
                'Product Description',
                style: AppStyles.bold.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: kPaddingHorizontal,
            //   ),
            //   child: Text(
            //     widget.product.productDescription,
            //     style: AppStyles.regular,
            //   ),
            // ),
            BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                if (state is ProductDetailLoaded) {
                  return reviews(state.rating, state.comments);
                }
                return const SizedBox();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
              ),
              child: Text(
                'Maybe you like',
                style: AppStyles.bold.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            listRecommendation(size),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: const Color(0xFF000000).withOpacity(0.1),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showBottomDialog(
                      context,
                      BoxAddToCart(
                        product: widget.product,
                      ),
                    );
                  },
                  child: const BoxCart(),
                ),
                const SizedBox(width: 15),
                // Expanded(
                //   child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                //     builder: (context, state) {
                //       if (state is ProductDetailLoaded) {
                //         double totalPrice =
                //             state.quantity.toDouble() * state.price;

                //         return CustomButton(
                //           margin: 0,
                //           content: 'Buy \$$totalPrice',
                //           onTap: () {
                //             _bloc.add(
                //               ProductDetailChecked(
                //                 idProduct: widget.product.id!,
                //                 quantity: state.quantity,
                //               ),
                //             );
                //           },
                //         );
                //       }
                //       return const SizedBox();
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToReviewOrderScreen(double totalPrice, int quantity) {
    Cart cart = Cart(product: widget.product, quantity: quantity);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FirstCheckOutScreen(
          orderTotal: totalPrice,
          carts: [cart],
          isFromCart: false,
        ),
      ),
    );
  }

  void navigateToReviewScreen() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => ReviewScreen(
    //       comments: widget.product.comments,
    //     ),
    //   ),
    // );
  }

  Widget listRecommendation(Size size) {
    return SizedBox(
      height: size.height * .12,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: productSuggestions.length,
        itemBuilder: (context, index) {
          Product product = productSuggestions[index];
          // return Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Image.asset(
          //     product.productImgList![0].imgUrl,
          //     fit: BoxFit.fitWidth,
          //     width: 113,
          //     height: 113,
          //   ),
          // );
        },
      ),
    );
  }

  Widget reviews(num currentRating, List<Comment> comments) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ReviewScreen(
              comments: comments,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingHorizontal,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review',
                  style: AppStyles.bold.copyWith(
                    fontSize: 16,
                  ),
                ),
                RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: currentRating.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: const EdgeInsets.only(right: 5.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: AppColors.secondary,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: navigateToReviewScreen,
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.gray,
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listImages() {
    return Container(
      color: const Color(0xFFF5F6F6),
      child: Stack(
        children: [
          // CarouselSlider(
          //   items: widget.product.productImgList!
          //       .map(
          //         (item) => Image.network(
          //           item.imgUrl,
          //           fit: BoxFit.cover,
          //           width: double.infinity,
          //         ),
          //       )
          //       .toList(),
          //   carouselController: controller,
          //   options: CarouselOptions(
          //     scrollPhysics: const BouncingScrollPhysics(),
          //     autoPlay: true,
          //     aspectRatio: 1.7,
          //     viewportFraction: 1,
          //     onPageChanged: (index, reason) {
          //       setState(() {
          //         currentIndex = index;
          //       });
          //     },
          //   ),
          // ),
          // Positioned(
          //   bottom: 10,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children:
          //         widget.product.productImgList!.asMap().entries.map((entry) {
          //       return GestureDetector(
          //         onTap: () => controller.animateToPage(entry.key),
          //         child: Container(
          //           width: 7.0,
          //           height: 7.0,
          //           margin: const EdgeInsets.symmetric(
          //             horizontal: 3.0,
          //           ),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: currentIndex == entry.key
          //                 ? AppColors.primary
          //                 : AppColors.primary.withOpacity(0.4),
          //           ),
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
