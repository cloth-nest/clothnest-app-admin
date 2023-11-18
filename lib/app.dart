import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/repository/address_repository.dart';
import 'package:grocery/data/repository/auth_repository.dart';
import 'package:grocery/data/repository/cart_repository.dart';
import 'package:grocery/data/repository/category_repository.dart';
import 'package:grocery/data/repository/comment_repository.dart';
import 'package:grocery/data/repository/coupon_repository.dart';
import 'package:grocery/data/repository/order_repository.dart';
import 'package:grocery/data/repository/product_repository.dart';
import 'package:grocery/data/repository/statistic_repository.dart';
import 'package:grocery/data/repository/user_repository.dart';
import 'package:grocery/data/repository/zalo_pay_repository.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/screens/admin/bottom_navigation_bar.dart/bottom_navigation_bar_screen.dart'
    as admin;
import 'package:grocery/presentation/screens/bottom_navigation_bar.dart/bottom_navigation_bar_screen.dart'
    as user;
import 'package:grocery/presentation/screens/onboarding/splash_screen.dart';
import 'package:grocery/presentation/services/add_edit_address_bloc/add_edit_address_bloc.dart';
import 'package:grocery/presentation/services/address_bloc/address_bloc.dart';
import 'package:grocery/presentation/services/admin/add_category_bloc/add_category_bloc.dart';
import 'package:grocery/presentation/services/admin/add_edit_coupon_bloc/add_edit_coupon_bloc.dart';
import 'package:grocery/presentation/services/admin/add_edit_product_bloc/add_edit_product_bloc.dart';
import 'package:grocery/presentation/services/admin/coupon_bloc/coupon_bloc.dart'
    as admin;
import 'package:grocery/presentation/services/admin/transaction_bloc/transaction_bloc.dart';
import 'package:grocery/presentation/services/admin/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:grocery/presentation/services/user/coupon_bloc/coupon_bloc.dart'
    as user;

import 'package:grocery/presentation/services/admin/statistic_bloc/statistic_bloc.dart';
import 'package:grocery/presentation/services/admin/statistic_detail_bloc/statistic_detail_bloc.dart';
import 'package:grocery/presentation/services/app_data.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_bloc.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_event.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_state.dart';
import 'package:grocery/presentation/services/bottom_navigation_bloc/cubit/navigation_cubit.dart';
import 'package:grocery/presentation/services/admin/categories_overview_bloc/categories_overview_bloc.dart';
import 'package:grocery/presentation/services/admin/detail_category_bloc/detail_category_bloc.dart';
import 'package:grocery/presentation/services/admin/edit_category_bloc/edit_category_bloc.dart';
import 'package:grocery/presentation/services/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:grocery/presentation/services/login_bloc/login_bloc.dart';
import 'package:grocery/presentation/services/admin/products_overview_bloc/products_overview_bloc.dart';
import 'package:grocery/presentation/services/profile_bloc/profile_bloc.dart';
import 'package:grocery/presentation/services/user/cart_bloc/cart_bloc.dart';
import 'package:grocery/presentation/services/user/category_detail_bloc/category_detail_bloc.dart';
import 'package:grocery/presentation/services/user/order_bloc/order_bloc.dart';
import 'package:grocery/presentation/services/user/product_detail_bloc/product_detail_bloc.dart';
import 'package:grocery/presentation/services/user/review_order_bloc/review_order_bloc.dart';
import 'package:grocery/presentation/services/user/second_checkout_bloc/second_checkout_bloc.dart';
import 'package:grocery/presentation/services/user/shop_bloc/shop_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<SharedPreferences> sharedFuture;

  @override
  void initState() {
    _initshared(); // Prioritize

    super.initState();
  }

  _initshared() async {
    sharedFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(sharedFuture),
      child: Consumer<AppData>(
        builder: (context, appData, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<NavigationCubit>(
                create: (context) => NavigationCubit(),
              ),
              BlocProvider<AuthenticationBloc>(
                create: (context) => AuthenticationBloc(
                  AuthRepository(appData),
                )..add(const AuthenticationStarted()),
              ),
              BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(
                  AuthRepository(appData),
                ),
              ),
              BlocProvider<CategoriesOverviewBloc>(
                create: (context) => CategoriesOverviewBloc(
                  CategoryRepository(appData),
                ),
              ),
              BlocProvider<AddCategoryBloc>(
                create: (context) => AddCategoryBloc(
                  CategoryRepository(appData),
                ),
              ),
              BlocProvider<DetailCategoryBloc>(
                create: (context) => DetailCategoryBloc(
                  CategoryRepository(appData),
                  ProductRepository(appData),
                ),
              ),
              BlocProvider<EditCategoryBloc>(
                create: (context) => EditCategoryBloc(
                  CategoryRepository(appData),
                ),
              ),
              BlocProvider<ProductsOverviewBloc>(
                create: (context) => ProductsOverviewBloc(),
              ),
              BlocProvider<AddEditProductBloc>(
                create: (context) => AddEditProductBloc(
                  ProductRepository(appData),
                ),
              ),
              BlocProvider<ShopBloc>(
                create: (context) => ShopBloc(
                  CategoryRepository(appData),
                ),
              ),
              BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(
                  AuthRepository(appData),
                  UserRepository(appData),
                ),
              ),
              BlocProvider<CategoryDetailBloc>(
                create: (context) => CategoryDetailBloc(
                  ProductRepository(appData),
                ),
              ),
              BlocProvider<AddressBloc>(
                create: (context) => AddressBloc(
                  AddressRepository(appData),
                ),
              ),
              BlocProvider<AddEditAddressBloc>(
                create: (context) => AddEditAddressBloc(
                  AddressRepository(appData),
                ),
              ),
              BlocProvider<EditProfileBloc>(
                create: (context) => EditProfileBloc(
                  UserRepository(appData),
                ),
              ),
              BlocProvider<ProductDetailBloc>(
                create: (context) => ProductDetailBloc(
                  CartRepository(appData),
                  ProductRepository(appData),
                  OrderRepository(appData),
                ),
              ),
              BlocProvider<CartBloc>(
                create: (context) => CartBloc(
                  CartRepository(appData),
                ),
              ),
              BlocProvider<SecondCheckoutBloc>(
                create: (context) => SecondCheckoutBloc(
                  AddressRepository(appData),
                  OrderRepository(appData),
                  CartRepository(appData),
                  ZaloPayRepository(),
                ),
              ),
              BlocProvider<OrderBloc>(
                create: (context) => OrderBloc(
                  OrderRepository(appData),
                ),
              ),
              BlocProvider<TransactionBloc>(
                create: (context) => TransactionBloc(
                  OrderRepository(appData),
                ),
              ),
              BlocProvider<admin.CouponBloc>(
                create: (context) => admin.CouponBloc(
                  CouponRepository(appData),
                ),
              ),
              BlocProvider<AddEditCouponBloc>(
                create: (context) => AddEditCouponBloc(
                  CouponRepository(appData),
                ),
              ),
              BlocProvider<StatisticBloc>(
                create: (context) => StatisticBloc(
                  StatisticRepository(appData),
                ),
              ),
              BlocProvider<StatisticDetailBloc>(
                create: (context) => StatisticDetailBloc(
                  StatisticRepository(appData),
                ),
              ),
              BlocProvider<user.CouponBloc>(
                create: (context) => user.CouponBloc(
                  CouponRepository(appData),
                ),
              ),
              BlocProvider<ReviewOrderBloc>(
                create: (context) => ReviewOrderBloc(
                  CommentRepository(appData),
                ),
              ),
              BlocProvider<TransactionDetailBloc>(
                create: (context) => TransactionDetailBloc(
                  OrderRepository(appData),
                ),
              ),
            ],
            child: MaterialApp(
              title: 'Gocery',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: AppColors.primary,
              ),
              home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is AuthenticatonUnAuthorized) {
                    return const SplashScreen();
                  } else if (state is AuthenticationAuthorized) {
                    if (state.role == "Admin") {
                      return const admin.BottomNavigationBarScreen();
                    } else {
                      return const user.BottomNavigationBarScreen();
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
