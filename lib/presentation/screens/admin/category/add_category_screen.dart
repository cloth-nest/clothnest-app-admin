import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/add_category_bloc/add_category_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/item_add_image.dart';
import 'package:grocery/presentation/widgets/item_image.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class AddCategoryScreen extends StatefulWidget {
  final int? parentId;

  const AddCategoryScreen({
    super.key,
    this.parentId,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  File? imageFile;
  final _addCategoryFormKey = GlobalKey<FormState>();
  Category? selectedCategory;
  @override
  void initState() {
    super.initState();
    context.read<AddCategoryBloc>().add(CategoryInit());
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
          } else {
            LoadingScreen().hide();
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
                    child: BlocBuilder<AddCategoryBloc, AddCategoryState>(
                      builder: (context, state) => CustomButton(
                        content: 'Add Category',
                        onTap: () => addCategory(state.selectedCategory?.id),
                        width: size.width * .4,
                      ),
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

  Widget comboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return Container(
      padding: const EdgeInsets.all(10),
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

  void addCategory(int? id) async {
    if (_addCategoryFormKey.currentState!.validate()) {
      context.read<AddCategoryBloc>().add(
            CategoryAdded(
              nameCategory: nameController.text,
              imageFile: imageFile,
              parentId: widget.parentId,
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
