import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/presentation/enum/enum.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/screens/admin/category/categories_screen.dart';
import 'package:grocery/presentation/screens/admin/product/products_screen.dart';
import 'package:grocery/presentation/screens/cart/cart_screen.dart';
import 'package:grocery/presentation/screens/order/order_screen.dart';
import 'package:grocery/presentation/screens/configuration/configuration_screen.dart';
import 'package:grocery/presentation/screens/side_menu/side_menu.dart';
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

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with SingleTickerProviderStateMixin {
  bool isSideMenuClosed = true;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    BlocProvider.of<NavigationCubit>(context)
        .getNavBarItem(NavBarItem.products);

    if (widget.index != 1) {
      BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.order);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: const Color(0xFFFAFAF9),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: size.height,
            child: SideMenu(
              callback: (title) {
                switch (title) {
                  case 'Products':
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavBarItem.products);
                    break;
                  case 'Categories':
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavBarItem.categories);
                    break;
                  case 'Configuration':
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavBarItem.profile);
                    break;

                  default:
                }
              },
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0001)
              //rotate 30 degree
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BlocBuilder<NavigationCubit, NavigationState>(
                    builder: (context, state) {
                      if (state.navBarItem == NavBarItem.categories) {
                        return const CategoriesScreen();
                      } else if (state.navBarItem == NavBarItem.cart) {
                        return const CartScreen();
                      } else if (state.navBarItem == NavBarItem.order) {
                        return const OrderScreen();
                      } else if (state.navBarItem == NavBarItem.products) {
                        return const ProductsScreen();
                      }
                      return const ConfigurationScreen();
                    },
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 220,
            top: 16,
            child: GestureDetector(
              onTap: () {
                if (isSideMenuClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(() {
                  isSideMenuClosed = !isSideMenuClosed;
                });
              },
              child: SafeArea(
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(left: 16),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 3),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: SvgPicture.asset(
                    isSideMenuClosed ? AppAssets.iconMenu : AppAssets.iconClose,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
