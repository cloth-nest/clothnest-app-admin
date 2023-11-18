import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/enum/enum.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/screens/cart/cart_screen.dart';
import 'package:grocery/presentation/screens/order/order_screen.dart';
import 'package:grocery/presentation/screens/profile/profile_screen.dart';
import 'package:grocery/presentation/screens/shop/shop_screen.dart';
import 'package:grocery/presentation/services/bottom_navigation_bloc/cubit/navigation_cubit.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final int index;

  const BottomNavigationBarScreen({
    Key? key,
    this.index = 1,
  }) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.shop);

    if (widget.index != 1) {
      BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.order);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        if (state.navBarItem == NavBarItem.shop) {
          return const ShopScreen();
        } else if (state.navBarItem == NavBarItem.cart) {
          return const CartScreen();
        } else if (state.navBarItem == NavBarItem.order) {
          return const OrderScreen();
        }
        return const ProfileScreen();
      }),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (contextx, state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.gray,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.icShop,
                width: 24,
                height: 24,
                color: state.index == 0 ? AppColors.primary : AppColors.gray,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.icCart,
                width: 24,
                height: 24,
                color: state.index == 1 ? AppColors.primary : AppColors.gray,
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.icOrder,
                width: 24,
                height: 24,
                color: state.index == 2 ? AppColors.primary : AppColors.gray,
              ),
              label: 'My Order',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.icProfile,
                width: 24,
                height: 24,
                color: state.index == 3 ? AppColors.primary : AppColors.gray,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: state.index,
          onTap: (index) {
            if (index == 0) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.shop);
            } else if (index == 1) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.cart);
            } else if (index == 2) {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.order);
            } else {
              BlocProvider.of<NavigationCubit>(context)
                  .getNavBarItem(NavBarItem.profile);
            }
          },
        );
      }),
    );
  }
}
