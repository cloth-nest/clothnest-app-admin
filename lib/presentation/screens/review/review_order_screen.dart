import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/user/review_order_bloc/review_order_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class ReviewOrderScreen extends StatefulWidget {
  final Order order;
  const ReviewOrderScreen({
    super.key,
    required this.order,
  });

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  final TextEditingController controller = TextEditingController();
  File? imageFile;
  ReviewOrderBloc get _bloc => BlocProvider.of<ReviewOrderBloc>(context);
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  double? rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Review your order',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: BlocConsumer<ReviewOrderBloc, ReviewOrderState>(
        listener: (context, state) {
          if (state is ReviewOrderLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is ReviewOrderFailure) {
            LoadingScreen().hide();
          } else {
            LoadingScreen().hide();
            Navigator.of(context).pop();
            showSnackBar(
              context,
              'Add comment successfully',
              const Icon(
                Icons.check,
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 5,
                  children: widget.order.products!
                      .map((e) => Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  e.thumbnail!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.productName,
                                    style: AppStyles.medium,
                                  ),
                                  Row(
                                    children: [
                                      Text('Quantity: ',
                                          style: AppStyles.regular),
                                      Text('2', style: AppStyles.medium),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Price: ', style: AppStyles.regular),
                                      Text('2', style: AppStyles.medium),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              _buildDivider(),
              const SizedBox(height: 10),
              _rating(),
              const SizedBox(height: 10),
              _buildDivider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Write your review',
                  style: AppStyles.semibold.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  height: 160,
                  child: TextField(
                    style: AppStyles.medium,
                    maxLines: null,
                    expands: true,
                    controller: controller,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintText:
                          'Write here your feed back about this product ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintStyle: AppStyles.regular.copyWith(fontSize: 14),
                      filled: true,
                      fillColor: AppColors.gray.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildDivider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your images',
                  style: AppStyles.semibold.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _image(),
              ),
              const SizedBox(height: 30),
              CustomButton(
                content: 'Review',
                onTap: () {
                  for (Product product in widget.order.products!) {
                    _bloc.add(
                      ReviewSubmitted(
                        image: imageFile!,
                        review: controller.text.trim(),
                        rating: rating!,
                        idProduct: product.id!,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 3,
      color: const Color(0xFFEEEEEE),
    );
  }

  Widget _rating() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'Quality of products',
            style: AppStyles.semibold.copyWith(
              fontSize: 15,
            ),
          ),
          const Spacer(),
          RatingBar.builder(
            initialRating: 2,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20,
            itemPadding: const EdgeInsets.only(right: 5.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: AppColors.secondary,
            ),
            onRatingUpdate: (value) {
              rating = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _image() {
    return InkWell(
      onTap: pickImage,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.gray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8)),
        height: 150,
        child: imageFile == null
            ? const Center(
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 3,
                      top: 3,
                      child: GestureDetector(
                        onTap: removeImage,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    List<File> files = [];

    if (result != null) {
      for (var path in result.paths) {
        File file = File(path!);
        files.add(file);
      }
      if (mounted) {
        setState(() {
          imageFile = files[0];
        });
      }
    } else {
      // User canceled the picker
    }
  }

  void removeImage() {
    if (mounted) {
      setState(() {
        imageFile = null;
      });
    }
  }
}
