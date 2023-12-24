import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/product_type_data_source.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/product_type/components/assign_attribute_dialog.dart';
import 'package:grocery/presentation/screens/product_type/components/product_type_table_2.dart';
import 'package:grocery/presentation/services/admin/bloc/detail_product_type_bloc.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class DetailProductTypeScreen extends StatefulWidget {
  final ProductType productType;

  const DetailProductTypeScreen({
    super.key,
    required this.productType,
  });

  @override
  State<DetailProductTypeScreen> createState() =>
      _DetailProductTypeScreenState();
}

class _DetailProductTypeScreenState extends State<DetailProductTypeScreen> {
  final TextEditingController nameController = TextEditingController();
  DetailProductTypeBloc get _bloc =>
      BlocProvider.of<DetailProductTypeBloc>(context);

  @override
  void initState() {
    super.initState();
    nameController.text = widget.productType.name;
    _bloc.add(DetailProductTypeInit(productTypeId: widget.productType.id));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;
  bool _sortAscending = true;
  ProductTypeDataSourceAsync2? productAttributesSourceAsync;

  void sort(
    bool ascending,
  ) {
    var columnName = "Product Type";
    productAttributesSourceAsync?.sort(columnName, ascending);
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          widget.productType.name,
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
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
                  'Product Type Name',
                  style: AppStyles.medium,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  hintText: 'Product Type Name',
                  controller: nameController,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Product Attributes',
                      style: AppStyles.semibold,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (_) => const AssignAttributeDialog(),
                        );
                      },
                      child: Text(
                        'Assign attributes',
                        style: AppStyles.medium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildDivider(),
                const SizedBox(height: 10),
                BlocBuilder<DetailProductTypeBloc, DetailProductTypeState>(
                    builder: (context, state) {
                  if (state is DetailProductTypeLoading) {
                    return LoadingScreen().showLoadingWidget();
                  } else if (state is DetailProductTypeInitial) {
                    return _buildProductAttributesTable(
                        ProductTypeDataSourceAsync2(
                            productTypes: state.productAttributes,
                            context: context));
                  }
                  return LoadingScreen().showLoadingWidget();
                }),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Variant Attributes',
                      style: AppStyles.semibold,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {},
                      child: Text(
                        'Assign attributes',
                        style: AppStyles.medium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildDivider(),
                const SizedBox(height: 10),
                BlocBuilder<DetailProductTypeBloc, DetailProductTypeState>(
                    builder: (context, state) {
                  if (state is DetailProductTypeLoading) {
                    return LoadingScreen().showLoadingWidget();
                  } else if (state is DetailProductTypeInitial) {
                    return _buildProductAttributesTable(
                        ProductTypeDataSourceAsync2(
                            productTypes: state.variantAttributes,
                            context: context));
                  }
                  return LoadingScreen().showLoadingWidget();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 3,
      color: Colors.black12,
    );
  }

  _buildProductAttributesTable(
      ProductTypeDataSourceAsync2? productTypeDataSourceAsync) {
    return ProductTypesTable2(
      controller: _controller,
      columns: _columns,
      productTypeDataSourceAsync: productTypeDataSourceAsync,
      onPageChanged: (rowIndex) {},
      onRowsPerPageChanged: (value) {},
      rowsPerPage: _rowsPerPage,
      sortAscending: sortAscending,
    );
  }
}
