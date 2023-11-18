import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/user/product_detail_bloc/product_detail_bloc.dart';

class EditProductCart extends StatefulWidget {
  final String idProduct;
  const EditProductCart({
    super.key,
    required this.idProduct,
  });

  @override
  State<EditProductCart> createState() => _EditProductCartState();
}

class _EditProductCartState extends State<EditProductCart> {
  ProductDetailBloc get _bloc => BlocProvider.of<ProductDetailBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoaded) {
          int quantity = state.quantity;

          return Row(
            children: [
              iconEdit(
                const Positioned(
                  bottom: 7,
                  child: Icon(
                    Icons.minimize,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ),
                () {
                  _bloc.add(
                    ProductDetailRemoved(
                      idProduct: widget.idProduct,
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text('$quantity', style: AppStyles.bold),
              const SizedBox(width: 10),
              iconEdit(
                const Icon(
                  Icons.add,
                  size: 17,
                  color: AppColors.primary,
                ),
                () {
                  _bloc.add(
                    ProductDetailAdded(
                      idProduct: widget.idProduct,
                    ),
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget iconEdit(Widget child, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
