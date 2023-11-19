import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/edit_category_bloc/edit_category_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/item_add_image.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

import '../../../../data/services/cloudinary_service.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;

  const EditCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  File? fileImage;
  late String img;
  final _addCategoryFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.category.name;
    img = widget.category.image ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        isCenterTitle: true,
        title: Text(
          widget.category.name,
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: BlocListener<EditCategoryBloc, EditCategoryState>(
        listener: (context, state) {
          if (state is EditCategoryLoading) {
            LoadingScreen().show(context: context);
          } else if (state is EditCategoryFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(
                Icons.error_outline,
              ),
            );
          } else if (state is EditCategorySuccess) {
            LoadingScreen().hide();
            Navigator.of(context).pop(state.newCategory);
            showSnackBar(
              context,
              'Edit successfully',
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
            );
          }
        },
        child: Form(
          key: _addCategoryFormKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldInput(
                    hintText: 'Name Category',
                    controller: nameController,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Display Image',
                    style: AppStyles.medium.copyWith(),
                  ),
                  const SizedBox(height: 10),
                  img.isEmpty
                      ? ItemAddImage(
                          callback: (files) async {
                            img = await uploadImage(files[0]);

                            setState(
                              () {
                                fileImage = files[0];
                              },
                            );
                          },
                          index: 0,
                        )
                      : imageAdded(),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      content: 'Update Category',
                      onTap: updateCategory,
                      width: size.width * .5,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageAdded() {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 80,
            width: 80,
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
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
    );
  }

  void removeImage() {
    setState(() {
      img = "";
    });
  }

  void updateCategory() async {
    if (_addCategoryFormKey.currentState!.validate()) {
      Category category = Category(
          name: nameController.text,
          image: img,
          id: widget.category.id,
          level: 0);
      context
          .read<EditCategoryBloc>()
          .add(EditCategorySubmitted(newCategory: category));
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String? urlImage =
        await CloudinaryService().uploadImage(imageFile.path, 'categories');
    return urlImage ?? '';
  }
}
