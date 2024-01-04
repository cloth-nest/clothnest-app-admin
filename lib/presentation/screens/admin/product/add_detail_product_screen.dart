import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/bloc/add_detail_product_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/item_upload_group.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class AddDetailProductScreen extends StatefulWidget {
  final Product product;

  const AddDetailProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<AddDetailProductScreen> createState() => _AddDetailProductScreenState();
}

class _AddDetailProductScreenState extends State<AddDetailProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final _addEditProductFormKey = GlobalKey<FormState>();

  AddDetailProductBloc get _bloc =>
      BlocProvider.of<AddDetailProductBloc>(context);

  ProductType? selectedProductType;
  Category? selectedCategory;
  List<Map<String, dynamic>>? selectedAttributeValues = [];
  List<Map<String, dynamic>>? selectedWarehouses = [];

  bool isAdded = false;

  List<File> imageFiles = [];
  List<String> urlImages = [];

  @override
  void initState() {
    super.initState();
    _bloc.add(AddDetailProductStarted(idProduct: widget.product.id));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    weightController.dispose();
    skuController.dispose();
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
          'Add product variant',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<AddDetailProductBloc, AddDetailProductState>(
        listener: (context, state) {
          if (state is AddDetailProductLoading) {
            LoadingScreen().show(context: context);
          } else if (state is AddDetailProductInitial) {
            for (var element in state.productAttributes) {
              selectedAttributeValues?.add({
                'productType': element['productType'],
                'attributeValues': element['attributeValues'].first,
                'id': (element['productType'] as ProductType).id,
                'valueId': element['attributeValues'].first.id,
              });
            }
            for (var element in state.warehouses) {
              selectedWarehouses?.add({
                'warehouse': element['warehouse'],
                'idWarehouse': element['idWarehouse'],
                'controller': TextEditingController(),
              });
            }

            LoadingScreen().hide();
          } else if (state is AddDetailProductSuccess) {
            LoadingScreen().hide();

            showSnackBar(
              context,
              'Add product variant successfully',
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
            );
          } else {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
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
                      'Variant Name',
                      style: AppStyles.medium,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Variant Name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Price',
                      style: AppStyles.medium,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Price',
                      controller: priceController,
                      type: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Weight',
                      style: AppStyles.medium,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Weight',
                      controller: weightController,
                      type: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sku',
                      style: AppStyles.medium,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Sku',
                      controller: skuController,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Media',
                      style: AppStyles.semibold,
                    ),
                    const SizedBox(height: 5),
                    _buildDivider(),
                    const SizedBox(height: 10),
                    ItemUploadGroup(
                      images: imageFiles,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Variant Selection Attributes',
                      style: AppStyles.semibold,
                    ),
                    const SizedBox(height: 5),
                    _buildDivider(),
                    const SizedBox(height: 10),
                    BlocBuilder<AddDetailProductBloc, AddDetailProductState>(
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
                                          'id': (map['productType']
                                                  as ProductType)
                                              .id,
                                          'valueId': p0.id,
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
                    const SizedBox(height: 20),
                    Text(
                      'Stock',
                      style: AppStyles.semibold,
                    ),
                    const SizedBox(height: 5),
                    _buildDivider(),
                    const SizedBox(height: 10),
                    BlocBuilder<AddDetailProductBloc, AddDetailProductState>(
                        builder: (context, state) {
                      if (state.warehouses.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map = state.warehouses[index];

                            final quantity =
                                selectedWarehouses?[index]['quantity'];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      map['warehouse'],
                                      style: AppStyles.medium,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: TextFieldInput(
                                      type: TextInputType.number,
                                      hintText: '',
                                      controller: quantity == null
                                          ? TextEditingController()
                                          : TextEditingController(
                                              text: quantity.toString(),
                                            ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedWarehouses?[index] = {
                                            'warehouse': map['warehouse'],
                                            'idWarehouse': map['idWarehouse'],
                                            'quantity': value,
                                          };
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: state.warehouses.length,
                        );
                      }
                      return const SizedBox();
                    }),
                    Center(
                      child: CustomButton(
                        margin: 0,
                        content: 'Add Variant',
                        onTap: () => handleButtonPressed(),
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

  void handleButtonPressed() {
    addProduct();
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
      AddDetailProductAdded(
        idProduct: widget.product.id,
        files: imageFiles,
        selectedAttributeValues: selectedAttributeValues,
        variantName: nameController.text.trim(),
        price: priceController.text.trim(),
        selectedWarehouses: selectedWarehouses,
        weight: weightController.text.trim(),
        sku: skuController.text.trim(),
      ),
    );
  }

  void editProduct(Product product) {
    // _bloc.add(
    //   ProductEditted(product: product, imageFiles: imageFiles),
    // );
  }
}
