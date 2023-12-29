import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/detail_product.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/bloc/detail_product_bloc.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _addEditProductFormKey = GlobalKey<FormState>();
  DetailProductBloc get _bloc => BlocProvider.of<DetailProductBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(DetailProductStarted(idProduct: widget.product.id));
    nameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset(AppAssets.icBack),
        ),
        title: Text(
          widget.product.name,
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          if (state is DetailProductInitial) {
            DetailProduct detailProduct = state.product;
            return Form(
              key: _addEditProductFormKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'General Information',
                        style: AppStyles.semibold,
                      ),
                      const SizedBox(height: 5),
                      _buildDivider(),
                      const SizedBox(height: 10),
                      Text(
                        'Product Type: ${detailProduct.productType.name}',
                        style: AppStyles.medium,
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(height: 10),
                      Text(
                        'Product Name',
                        style: AppStyles.medium,
                      ),
                      const SizedBox(height: 5),
                      TextFieldInput(
                        hintText: 'Name Product',
                        controller: nameController,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Product Description',
                        style: AppStyles.medium,
                      ),
                      const SizedBox(height: 5),
                      TextFieldInput(
                        hintText: 'Description',
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Media',
                        style: AppStyles.semibold,
                      ),
                      const SizedBox(height: 5),
                      _buildDivider(),
                      const SizedBox(height: 10),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: detailProduct.productImages.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            detailProduct.productImages[index].imgUrl,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: AppColors.box);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Bar Code',
                        style: AppStyles.semibold,
                      ),
                      const SizedBox(height: 5),
                      _buildDivider(),
                      const SizedBox(height: 20),
                      Center(
                        child: BarcodeWidget(
                          barcode: Barcode.code128(escapes: true),
                          data: widget.product.id.toString(),
                          width: 400,
                          height: 160,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return LoadingScreen().showLoadingWidget();
        },
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 3,
      color: Colors.black12,
    );
  }
}
