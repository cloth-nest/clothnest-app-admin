import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery/data/models/coupon.dart';
import 'package:grocery/data/services/cloudinary_service.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/add_edit_coupon_bloc/add_edit_coupon_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/item_add_image.dart';
import 'package:grocery/presentation/widgets/item_image.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';
import 'package:intl/intl.dart';

class AddCouponScreen extends StatefulWidget {
  const AddCouponScreen({super.key});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final TextEditingController couponTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController pricePointAcceptController =
      TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  final List<String> couponTypes = [
    'DiscountPercent',
    'DiscountValue',
    'Freeship',
  ];
  String valueCoupon = 'DiscountPercent';
  DateTime valueFromDate = DateTime.now();
  DateTime valueEndDate = DateTime.now();

  File? imageFile;
  final _addCouponFormKey = GlobalKey<FormState>();
  AddEditCouponBloc get _bloc => BlocProvider.of<AddEditCouponBloc>(context);

  @override
  void dispose() {
    super.dispose();
    couponTypeController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    pricePointAcceptController.dispose();
    fromDateController.dispose();
    endDateController.dispose();
    discountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Add Coupon',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<AddEditCouponBloc, AddEditCouponState>(
        listener: (context, state) {
          if (state is AddEditCouponLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is AddEditCouponFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(Icons.error_outline),
            );
          } else {
            LoadingScreen().hide();
            Navigator.of(context).pop();
            showSnackBar(
              context,
              'Add coupon successfully',
              const Icon(Icons.check),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _addCouponFormKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    comboBox(
                      couponTypes,
                      (value) {
                        setState(() {
                          valueCoupon = value;
                        });
                      },
                      valueCoupon,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Description',
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Quantity',
                      controller: quantityController,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Price Point Accept',
                      controller: pricePointAcceptController,
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: 'Discount',
                      controller: discountController,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025),
                            ).then((value) {
                              setState(() {
                                if (value != null) {
                                  valueFromDate = value;
                                  fromDateController.text =
                                      DateFormat('dd/MM/yyyy').format(value);
                                }
                              });
                            });
                          },
                          child: const Icon(
                            FontAwesomeIcons.calendar,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFieldInput(
                            hintText: 'From Date',
                            controller: fromDateController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025),
                            ).then((value) {
                              setState(() {
                                if (value != null) {
                                  valueEndDate = value;
                                  endDateController.text =
                                      DateFormat('dd/MM/yyyy').format(value);
                                }
                              });
                            });
                          },
                          child: const Icon(
                            FontAwesomeIcons.calendar,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFieldInput(
                            hintText: 'End Date',
                            controller: endDateController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Display Image',
                      style: AppStyles.medium.copyWith(),
                    ),
                    const SizedBox(height: 10),
                    imageFile == null
                        ? ItemAddImage(
                            callback: (files) {
                              setState(
                                () {
                                  imageFile = files[0];
                                },
                              );
                            },
                            index: 0)
                        : SizedBox(
                            height: 80,
                            width: 80,
                            child: ItemImage(
                              fileImage: imageFile!,
                              callback: (index) {
                                setState(
                                  () {
                                    imageFile = null;
                                  },
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomButton(
                        content: 'Add Coupon',
                        onTap: addCoupon,
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

  void addCoupon() async {
    if (_addCouponFormKey.currentState!.validate() && imageFile != null) {
      Coupon coupon = Coupon(
        fromDate: valueFromDate.toUtc().toIso8601String(),
        endDate: valueEndDate.toUtc().toIso8601String(),
        couponType: valueCoupon,
        discount: int.parse(discountController.text.trim()),
        pricePointAccept: int.parse(pricePointAcceptController.text.trim()),
        quantity: int.parse(quantityController.text.trim()),
        description: descriptionController.text.trim(),
      );
      _bloc.add(ButtonAddCouponPressed(coupon: coupon, imageFile: imageFile!));
    }
  }

  Widget comboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
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
                    e,
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
}
