import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/add_product_bloc/add_product_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class AddProductScreen extends StatefulWidget {
  final ProductType productType;
  final List<ProductType> productTypes;

  const AddProductScreen({
    super.key,
    required this.productType,
    required this.productTypes,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _addEditProductFormKey = GlobalKey<FormState>();
  AddProductBloc get _bloc => BlocProvider.of<AddProductBloc>(context);

  ProductType? selectedProductType;
  Category? selectedCategory;
  List<Map<String, dynamic>>? selectedAttributeValues = [];
  bool isAdded = false;

  @override
  void initState() {
    super.initState();
    selectedProductType = widget.productType;

    _bloc.add(AddProductStarted(productTypeId: selectedProductType!.id));
    // categoryController.text = widget.idCategory.toString();
    // _bloc.add(const AddEditProductCleared());
    // _bloc.add(AddEditProductStarted(product: widget.product));
  }

  @override
  void dispose() {
    super.dispose();
    // nameController.dispose();
    // descriptionController.dispose();
    // discountController.dispose();
    // quantityController.dispose();
    // categoryController.dispose();
    // priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(isAdded),
          child: Image.asset(AppAssets.icBack),
        ),
        title: Text(
          'Add a product',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<AddProductBloc, AddProductState>(
        listener: (context, state) {
          if (state is AddProductLoading) {
            LoadingScreen().show(context: context);
          } else if (state is AddProductFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            );
          } else if (state is AddProductSuccess) {
            LoadingScreen().hide();
            isAdded = true;
            showSnackBar(
              context,
              'Add product successfully',
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
            );
          } else if (state is EditProductSuccess) {
            LoadingScreen().hide();

            Navigator.of(context).pop([state.product, "edit"]);

            showSnackBar(
              context,
              'Edit product successfully',
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
            );
          } else if (state is AddProductInitial) {
            selectedCategory = state.categories.first;
            for (var element in state.productAttributes) {
              selectedAttributeValues?.add({
                'productType': element['productType'],
                'attributeValues': element['attributeValues'].first,
              });
            }
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          String headerText = "";

          if (state is AddProductInitial) {
            headerText = state.headerText;

            // if (state.product != null) {
            //   Product product = state.product!;
            //   nameController.text = product.productName;
            //   descriptionController.text = product.productDescription;
            //   discountController.text = product.discount.toString();
            //   quantityController.text = "20";
            //   priceController.text = product.price.toString();
            //   unitController.text = product.unit.toString();

            //   for (var image in state.product!.productImgList!) {
            //     urlImages.add(image.imgUrl);
            //   }
            // }
          }
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
                      'Product Type',
                      style: AppStyles.medium,
                    ),
                    const SizedBox(height: 5),
                    comboBox(widget.productTypes, (p0) {
                      setState(() {
                        selectedProductType = p0;
                      });
                    }, selectedProductType),
                    const SizedBox(height: 10),
                    Text(
                      'Category',
                      style: AppStyles.medium,
                    ),
                    const SizedBox(height: 5),
                    BlocBuilder<AddProductBloc, AddProductState>(
                        builder: (context, state) {
                      if (state.categories.isNotEmpty) {
                        return comboBox(state.categories, (p0) {
                          setState(() {
                            selectedCategory = p0;
                          });
                        }, selectedCategory);
                      }
                      return const SizedBox();
                    }),
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
                      'Attributes',
                      style: AppStyles.semibold,
                    ),
                    const SizedBox(height: 5),
                    _buildDivider(),
                    const SizedBox(height: 10),
                    BlocBuilder<AddProductBloc, AddProductState>(
                        builder: (context, state) {
                      if (state.productAttributes.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                state.productAttributes[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    (map['productType'] as ProductType).name,
                                    style: AppStyles.medium,
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 300,
                                    height: 50,
                                    child: attributeComboBox(
                                        map['attributeValues'], (p0) {
                                      setState(() {
                                        selectedAttributeValues?[index] = {
                                          "productType": map['productType'],
                                          "attributeValues": p0,
                                        };
                                      });
                                    },
                                        selectedAttributeValues?[index]
                                            ['attributeValues']),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: state.productAttributes.length,
                        );
                      }
                      return const SizedBox();
                    }),
                    Center(
                      child: CustomButton(
                        margin: 0,
                        content: 'Create Product',
                        onTap: () => handleButtonPressed(headerText),
                        width: size.width * .4,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget attributeComboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.gray,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          isExpanded: true,
          value: value,
          style: AppStyles.medium,
          dropdownColor: Colors.white,
          items: source
              .map(
                (e) => DropdownMenuItem<dynamic>(
                  value: e,
                  child: Text(
                    '${e.value}',
                    style: AppStyles.medium,
                  ),
                ),
              )
              .toList(),
          onChanged: callback,
        ),
      ),
    );
  }

  Widget comboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.gray,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          isExpanded: true,
          value: value,
          style: AppStyles.medium,
          dropdownColor: Colors.white,
          items: source
              .map(
                (e) => DropdownMenuItem<dynamic>(
                  value: e,
                  child: Text(
                    '${e.name}',
                    style: AppStyles.medium,
                  ),
                ),
              )
              .toList(),
          onChanged: callback,
        ),
      ),
    );
  }

  void handleButtonPressed(String headerText) {
    if (_addEditProductFormKey.currentState!.validate()) {
      addProduct();
    }
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 3,
      color: Colors.black12,
    );
  }

  void addProduct() {
    _bloc.add(
      ProductAdded(
        productDescription: descriptionController.text.trim(),
        productName: nameController.text.trim(),
        productTypeId: selectedProductType?.id ?? -1,
        categoryId: selectedCategory?.id ?? -1,
        attributes: selectedAttributeValues ?? [],
      ),
    );
  }

  void editProduct(Product product) {
    // _bloc.add(
    //   ProductEditted(product: product, imageFiles: imageFiles),
    // );
  }
}
