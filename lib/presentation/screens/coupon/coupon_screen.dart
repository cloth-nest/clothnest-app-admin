import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/coupon.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/coupon/components/item_coupon.dart';
import 'package:grocery/presentation/services/user/coupon_bloc/coupon_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  CouponBloc get _bloc => BlocProvider.of<CouponBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(CouponStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Choose Coupons',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: BlocConsumer<CouponBloc, CouponState>(
        listener: (context, state) {
          if (state is CouponFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(Icons.error_outline),
            );
          } else if (state is CouponLoading) {
            LoadingScreen().show(context: context);
          } else if (state is CouponSuccess) {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is CouponSuccess) {
            List<Coupon> coupons = state.coupons;

            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ItemCoupon(
                  coupon: coupons[index],
                  callback: (valueCoupon) {
                    Navigator.of(context).pop(valueCoupon);
                  },
                );
              },
              itemCount: coupons.length,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
