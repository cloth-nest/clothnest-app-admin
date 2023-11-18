import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/add_category_bloc/add_category_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/item_add_image.dart';
import 'package:grocery/presentation/widgets/item_image.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  File? imageFile;
  final _addCategoryFormKey = GlobalKey<FormState>();
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
        title: Text(
          'Add a Category',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<AddCategoryBloc, AddCategoryState>(
        listener: (context, state) {
          if (state is AddCategoryLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is AddCategorySuccess) {
            LoadingScreen().hide();
            Navigator.of(context).pop(state.newCategory);
          } else if (state is AddCategoryFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(Icons.error_outline),
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
                      content: 'Add Category',
                      onTap: addCategory,
                      width: size.width * .4,
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

  void addCategory() async {
    if (_addCategoryFormKey.currentState!.validate() && imageFile != null) {
      context.read<AddCategoryBloc>().add(
            CategoryAdded(
              nameCategory: nameController.text,
              imageFile: imageFile!,
            ),
          );
    } else {
      showSnackBar(
        context,
        'Please choose image',
        const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        messageColor: Colors.red,
      );
    }
  }
}
