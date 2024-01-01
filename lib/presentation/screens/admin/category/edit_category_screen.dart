import 'dart:io';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/categories_data_source.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/category/add_category_screen.dart';
import 'package:grocery/presentation/screens/admin/category/components/categories_table.dart';
import 'package:grocery/presentation/screens/admin/product/components/products_table.dart';
import 'package:grocery/presentation/screens/bottom_navigation_bar.dart/bottom_navigation_bar_screen.dart';
import 'package:grocery/presentation/services/admin/edit_category_bloc/edit_category_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/item_add_image.dart';
import 'package:grocery/presentation/widgets/item_image.dart';
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

class _EditCategoryScreenState extends State<EditCategoryScreen>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  File? fileImage;
  late String img;
  final _addCategoryFormKey = GlobalKey<FormState>();
  late TabController _tabController;
  final PaginatorController _controller = PaginatorController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.category.name;
    img = widget.category.bgImgUrl ?? '';
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    context
        .read<EditCategoryBloc>()
        .add(EditCategoryInit(id: widget.category.id, context: context));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    _tabController.dispose();
    _controller.dispose();
  }

  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Category name'),
        ),
        onSort: (columnIndex, ascending) => () {
          setState(() {});
        },
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Subcategories',
          ),
        ),
        onSort: (columnIndex, ascending) => () {
          setState(() {});
        },
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Number of products'),
        ),
        onSort: (columnIndex, ascending) => () {
          setState(() {});
        },
      ),
    ];
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const BottomNavigationBarScreen(),
              ),
            );
            showSnackBar(
              context,
              'Edit successfully',
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
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
              child: SizedBox(
                height: size.height,
                width: size.width,
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
                    fileImage == null
                        ? img.isEmpty
                            ? ItemAddImage(
                                callback: (files) async {
                                  setState(
                                    () {
                                      fileImage = files[0];
                                    },
                                  );
                                },
                                index: 0,
                              )
                            : imageAdded()
                        : SizedBox(
                            height: 80,
                            width: 80,
                            child: ItemImage(
                              fileImage: fileImage!,
                              callback: (index) {
                                if (fileImage != null) {
                                  debugPrint('###${fileImage!.path}');
                                } else {
                                  debugPrint('###null');
                                }
                                setState(() {
                                  fileImage = null;
                                });
                              },
                            ),
                          ),
                    const SizedBox(height: 35),
                    Center(
                      child: CustomButton(
                        content: 'Update Category',
                        onTap: updateCategory,
                        width: size.width * .5,
                      ),
                    ),
                    const SizedBox(height: 35),
                    TabBar(
                      controller: _tabController,
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      indicatorColor: AppColors.black,
                      labelColor: AppColors.textLightBasic,
                      labelStyle: AppStyles.regular,
                      labelPadding: const EdgeInsets.only(bottom: 10),
                      unselectedLabelColor: AppColors.textGray999,
                      tabs: const [
                        Text(
                          'Subcategories',
                        ),
                        Text(
                          'Products',
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          BlocBuilder<EditCategoryBloc, EditCategoryState>(
                              builder: (context, state) {
                            if (state is EditCategoryLoaded) {
                              if (state.categoryDataSource != null) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'All Subcategories',
                                          style: AppStyles.semibold,
                                        ),
                                        GestureDetector(
                                          onTap: () => handleAddCategory(
                                              widget.category.id),
                                          child: Text(
                                            'Create subcategory',
                                            style: AppStyles.medium.copyWith(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    CategoriesTable(
                                      controller: _controller,
                                      columns: _columns,
                                      categoryDataSource:
                                          state.categoryDataSource,
                                      onPageChanged: (rowIndex) {},
                                      onRowsPerPageChanged: (value) {},
                                    ),
                                  ],
                                );
                              }
                            }

                            return const SizedBox();
                          }),
                          BlocBuilder<EditCategoryBloc, EditCategoryState>(
                              builder: (context, state) {
                            if (state is EditCategoryLoaded) {
                              if (state.productDataSourceAsync != null) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'All Products',
                                          style: AppStyles.semibold,
                                        ),
                                        GestureDetector(
                                          onTap: () => handleAddCategory(
                                              widget.category.id),
                                          child: Text(
                                            'Create products',
                                            style: AppStyles.medium.copyWith(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ProductsTable(
                                      controller: _controller,
                                      columns: [
                                        DataColumn(
                                          label: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Product'),
                                          ),
                                          onSort: (columnIndex, ascending) =>
                                              () {
                                            setState(() {});
                                          },
                                        ),
                                        DataColumn(
                                          label: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Type',
                                            ),
                                          ),
                                          onSort: (columnIndex, ascending) =>
                                              () {
                                            setState(() {});
                                          },
                                        ),
                                        DataColumn(
                                          label: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Description'),
                                          ),
                                          onSort: (columnIndex, ascending) =>
                                              () {
                                            setState(() {});
                                          },
                                        ),
                                        const DataColumn2(
                                          label: SizedBox(
                                            width: 50,
                                          ),
                                          size: ColumnSize.S,
                                          fixedWidth: 40,
                                        ),
                                      ],
                                      productDataSource:
                                          state.productDataSourceAsync,
                                      onPageChanged: (rowIndex) {},
                                      onRowsPerPageChanged: (value) {},
                                    ),
                                  ],
                                );
                              }
                            }

                            return const SizedBox();
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleAddCategory(int? parentId) async {
    final newCategory = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddCategoryScreen(
          parentId: parentId,
        ),
      ),
    );

    if (newCategory != null) {
      context
          .read<EditCategoryBloc>()
          .add(EditCategoryInit(id: widget.category.id, context: context));
    }
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
        bgImgUrl: img,
        id: widget.category.id,
        level: 0,
      );
      context.read<EditCategoryBloc>().add(EditCategorySubmitted(
            newCategory: category,
            context: context,
            fileImage: fileImage,
          ));
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String? urlImage =
        await CloudinaryService().uploadImage(imageFile.path, 'categories');
    return urlImage ?? '';
  }
}
