import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/review/components/item_review.dart';
import 'package:grocery/presentation/services/user/review_order_bloc/review_order_bloc.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ProductReviewScreen extends StatefulWidget {
  final int idProduct;

  const ProductReviewScreen({
    super.key,
    required this.idProduct,
  });

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  ReviewOrderBloc get _bloc => BlocProvider.of<ReviewOrderBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(ReviewStarted(idProduct: widget.idProduct));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Reviews',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: BlocBuilder<ReviewOrderBloc, ReviewOrderState>(
          builder: (context, state) {
        if (state is ReviewOrderInitial) {
          if (state.comments.isEmpty) {
            return Center(
              child: Text(
                'There is no reviews',
                style: AppStyles.medium,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              _bloc.add(ReviewStarted(idProduct: widget.idProduct));
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.comments.length,
              itemBuilder: (BuildContext _, int index) {
                return ItemReview(
                  comment: state.comments[index],
                );
              },
            ),
          );
        } else {
          return LoadingScreen().showLoadingWidget();
        }
      }),
    );
  }
}
