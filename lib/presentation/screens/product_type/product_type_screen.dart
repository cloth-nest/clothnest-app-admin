import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/product_type_data_source.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/product_type/components/add_product_type_dialog.dart';
import 'package:grocery/presentation/screens/product_type/components/product_types_table.dart';
import 'package:grocery/presentation/services/product_attribute_bloc/product_attribute_bloc.dart';
import 'package:grocery/presentation/services/product_type_bloc/product_type_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class ProductTypeScreen extends StatefulWidget {
  const ProductTypeScreen({super.key});

  @override
  State<ProductTypeScreen> createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  ProductTypeBloc get _bloc => BlocProvider.of<ProductTypeBloc>(context);

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;
  bool _sortAscending = true;
  ProductTypeDataSourceAsync? dataSourceAsync;

  void sort(
    bool ascending,
  ) {
    var columnName = "Product Type";
    dataSourceAsync?.sort(columnName, ascending);
    setState(() {
      _sortAscending = ascending;
    });
  }

  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Id'),
        ),
        onSort: (columnIndex, ascending) => () {},
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Product Type',
          ),
        ),
        onSort: (columnIndex, ascending) {
          sort(ascending);
          setState(() {
            sortAscending = ascending;
          });
        },
      ),
      DataColumn2(
        size: ColumnSize.S,
        fixedWidth: 50,
        label: const SizedBox.shrink(),
        onSort: (columnIndex, ascending) {},
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(ProductTypeStarted(context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Product Types',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<ProductTypeBloc, ProductTypeState>(
        listener: (context, state) {
          if (state is ProductAttributeLoaded) {}
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _bloc.add(ProductTypeStarted(context));
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Product Types',
                          style: AppStyles.semibold,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => AddProductTypeDialog(
                                controller: TextEditingController(),
                              ),
                            );
                            if (result != null) {
                              _bloc.add(ProductTypeAdded(
                                  context, result[0], result[1]));
                            }
                          },
                          child: Text(
                            'Create product type',
                            style: AppStyles.medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocListener<ProductTypeBloc, ProductTypeState>(
                    listener: (context, state) {
                      if (state is ProductTypeError) {
                        if (state.errorMessage != 'ForbiddenError') {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => CupertinoAlertDialog(
                              title: const Text('Product Type Failed'),
                              content: Text(state.errorMessage),
                              actions: <Widget>[
                                CupertinoButton(
                                  onPressed: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: BlocBuilder<ProductTypeBloc, ProductTypeState>(
                        builder: (context, state) {
                      if (state is ProductTypeLoading) {
                        return LoadingScreen().showLoadingWidget();
                      } else if (state is ProductTypeError) {
                        if (state.errorMessage == 'ForbiddenError') {
                          return Center(
                            child: Text(
                              'You don\'t have permission to see product types',
                              style:
                                  AppStyles.medium.copyWith(color: Colors.red),
                            ),
                          );
                        }

                        return _buildProductTypeTable(dataSourceAsync);
                      } else if (state is ProductTypeLoaded) {
                        dataSourceAsync = state.productTypeDataSourceAsync;
                        ProductTypeDataSourceAsync? productTypeDataSourceAsync =
                            state.productTypeDataSourceAsync;

                        return _buildProductTypeTable(
                            productTypeDataSourceAsync);
                      }
                      return LoadingScreen().showLoadingWidget();
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildProductTypeTable(
      ProductTypeDataSourceAsync? productTypeDataSourceAsync) {
    return ProductTypesTable(
      controller: _controller,
      columns: _columns,
      productTypeDataSourceAsync: productTypeDataSourceAsync,
      onPageChanged: (rowIndex) {},
      onRowsPerPageChanged: (value) {
        _rowsPerPage = value!;
      },
      rowsPerPage: _rowsPerPage,
      sortAscending: sortAscending,
    );
  }
}
