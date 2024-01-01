import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/product_attributes_data_source.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/attributes/components/add_product_attribute_dialog.dart';
import 'package:grocery/presentation/screens/attributes/components/product_attributes_table.dart';
import 'package:grocery/presentation/services/product_attribute_bloc/product_attribute_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  ProductAttributeBloc get _bloc =>
      BlocProvider.of<ProductAttributeBloc>(context);

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;
  bool _sortAscending = true;
  ProductAttributeDataSourceAsync? dataSourceAsync;

  void sort(
    bool ascending,
  ) {
    var columnName = "Attribute";
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
            'Attribute',
          ),
        ),
        onSort: (columnIndex, ascending) {
          sort(ascending);
          setState(() {
            sortAscending = ascending;
          });
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(ProductAttributeStarted(context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Attributes',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<ProductAttributeBloc, ProductAttributeState>(
        listener: (context, state) {
          if (state is ProductAttributeLoaded) {
            if (state.isAdded != null) {
              showSnackBar(
                context,
                'Add product attribute successfully',
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              );
            }
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _bloc.add(ProductAttributeStarted(context));
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
                          'All attributes',
                          style: AppStyles.semibold,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => AddProductAttributeDialog(
                                controller: TextEditingController(),
                              ),
                            );
                            if (result != null && result != '') {
                              _bloc.add(ProductAttributeAdded(context, result));
                            }
                          },
                          child: Text(
                            'Create attribute',
                            style: AppStyles.medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ProductAttributeBloc, ProductAttributeState>(
                      builder: (context, state) {
                    if (state is ProductAttributeLoading) {
                      return LoadingScreen().showLoadingWidget();
                    } else if (state is ProductAttributeError) {
                      if (state.errorMessage == 'ForbiddenError') {
                        return Center(
                          child: Text(
                            'You don\'t have permission to see attributes',
                            style: AppStyles.medium.copyWith(color: Colors.red),
                          ),
                        );
                      }
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else if (state is ProductAttributeLoaded) {
                      dataSourceAsync = state.attributesDataSource;
                      ProductAttributeDataSourceAsync? attributeDataSource =
                          state.attributesDataSource;

                      return _buildAttributeTable(attributeDataSource);
                    }
                    return LoadingScreen().showLoadingWidget();
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAttributeTable(ProductAttributeDataSourceAsync? attributeDataSource) {
    return ProductAttributesTable(
      controller: _controller,
      columns: _columns,
      attributeDataSourceAsync: attributeDataSource,
      onPageChanged: (rowIndex) {},
      onRowsPerPageChanged: (value) {
        _rowsPerPage = value!;
      },
      rowsPerPage: _rowsPerPage,
      sortAscending: sortAscending,
    );
  }
}
