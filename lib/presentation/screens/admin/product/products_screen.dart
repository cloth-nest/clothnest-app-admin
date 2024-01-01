// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/products_data_source_async.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/product/add_product_screen.dart';
import 'package:grocery/presentation/screens/admin/product/components/choose_product_type_dialog.dart';
import 'package:grocery/presentation/screens/admin/product/components/products_table.dart';
import 'package:grocery/presentation/services/admin/products_overview_bloc/products_overview_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductsOverviewBloc get _bloc =>
      BlocProvider.of<ProductsOverviewBloc>(context);
  Product? newProductAdded;

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;

  @override
  void initState() {
    super.initState();
    _bloc.add(ProductsOverviewStarted(context: context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _bloc.add(ProductsOverviewStarted(context: context));
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Products',
                          style: AppStyles.semibold,
                        ),
                        GestureDetector(
                          onTap: () async {
                            List<ProductType> productTypes = [];

                            final result = await showDialog(
                              context: context,
                              builder: (_) => BlocBuilder<ProductsOverviewBloc,
                                  ProductsOverviewState>(
                                builder: (context, state) {
                                  if (state is ProductsOverviewSuccess) {
                                    productTypes = state.productTypes;
                                    return ChooseProductTypeDialog(
                                      productTypes: productTypes,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            );

                            if (result != null) {
                              final isAdded = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddProductScreen(
                                    productType: result,
                                    productTypes: productTypes,
                                  ),
                                ),
                              );
                              if (isAdded) {
                                _bloc.add(
                                    ProductsOverviewStarted(context: context));
                              }
                            }
                          },
                          child: Text(
                            'Create product',
                            style: AppStyles.medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //list categories
                  BlocBuilder<ProductsOverviewBloc, ProductsOverviewState>(
                    builder: (context, state) {
                      if (state is ProductsOverviewLoading) {
                        return LoadingScreen().showLoadingWidget();
                      } else if (state is ProductsOverviewSuccess) {
                        ProductDataSourceAsync? productDataSourceAsync =
                            state.dataSourceAsync;

                        return _buildProductTable(productDataSourceAsync);
                      } else if (state is ProductsOverviewFailure) {
                        if (state.errorMessage == 'ForbiddenError') {
                          return Center(
                            child: Text(
                              'You don\'t have permission to see products',
                              style:
                                  AppStyles.medium.copyWith(color: Colors.red),
                            ),
                          );
                        }
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      }

                      return LoadingScreen().showLoadingWidget();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Product'),
        ),
        onSort: (columnIndex, ascending) => () {
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
        onSort: (columnIndex, ascending) => () {
          setState(() {});
        },
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Description'),
        ),
        onSort: (columnIndex, ascending) => () {
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
    ];
  }

  _buildProductTable(ProductDataSourceAsync? productDataSourceAsync) {
    return ProductsTable(
      controller: _controller,
      columns: _columns,
      productDataSource: productDataSourceAsync,
      onPageChanged: (rowIndex) {},
      onRowsPerPageChanged: (value) {
        _rowsPerPage = value!;
      },
    );
  }

  void handleAddProduct() async {
    // final result = await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => AddEditProductScreen(
    //       product: null,
    //       idCategory: widget.idCategory,
    //     ),
    //   ),
    // );

    // if (result != null) {
    //   newProductAdded = result[0];
    //   _bloc.add(NewProductAdded(product: result[0]));
    // }
  }
}
