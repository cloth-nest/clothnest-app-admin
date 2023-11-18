import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/enum/enum.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/screens/admin/category/categories_screen.dart';
import 'package:grocery/presentation/screens/admin/statistic/statistic_screen.dart';
import 'package:grocery/presentation/screens/admin/transactions/transaction_screen.dart';
import 'package:grocery/presentation/screens/admin/profile/profile_screen.dart';
import 'package:grocery/presentation/services/bottom_navigation_bloc/cubit/navigation_cubit.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.shop);
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
          return const CategoriesScreen();
        } else if (state.navBarItem == NavBarItem.cart) {
          return const TransactionScreen();
        } else if (state.navBarItem == NavBarItem.order) {
          return const StatisticScreen();
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
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.icOrder,
                width: 24,
                height: 24,
                color: state.index == 1 ? AppColors.primary : AppColors.gray,
              ),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppAssets.icChart,
                width: 24,
                height: 24,
                color: state.index == 2 ? AppColors.primary : AppColors.gray,
              ),
              label: 'Statistic',
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
