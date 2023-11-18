import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/cart.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/checkout/components/item_review_order.dart';
import 'package:grocery/presentation/screens/checkout/first_checkout_screen.dart';
import 'package:grocery/presentation/services/user/cart_bloc/cart_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc get _bloc => BlocProvider.of<CartBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(CartStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        title: Text(
          'Cart',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoading) {
            LoadingScreen().show(context: context);
          } else if (state is CartFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(
                Icons.error_outline,
              ),
            );
          } else if (state is CartLoaded) {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is CartLoaded) {
            final List<Cart> carts = state.carts;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Cart cart = carts[index];

                      return ItemReviewOrder(
                        cart: cart,
                      );
                    },
                    itemCount: carts.length,
                  ),
                  if (carts.isNotEmpty)
                    CustomButton(
                      margin: 0,
                      content: 'Checkout',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FirstCheckOutScreen(
                              orderTotal: state.totalMoney,
                              carts: state.carts,
                              isFromCart: true,
                            ),
                          ),
                        );
                      },
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
}
