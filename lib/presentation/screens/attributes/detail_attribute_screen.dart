import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attribute_values_data_source.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/attributes/components/add_attribute_value_dialog.dart';
import 'package:grocery/presentation/screens/attributes/components/attribute_values_table.dart';
import 'package:grocery/presentation/services/detail_attribute_bloc/detail_attribute_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class DetailAttributeScreen extends StatefulWidget {
  final String title;
  final int id;

  const DetailAttributeScreen({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  State<DetailAttributeScreen> createState() => _DetailAttributeScreenState();
}

class _DetailAttributeScreenState extends State<DetailAttributeScreen> {
  DetailAttributeBloc get _bloc =>
      BlocProvider.of<DetailAttributeBloc>(context);

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;

  final TextEditingController attributeNameController = TextEditingController();

  bool isActive = false;
  String title = '';
  AttributeValueDataSourceAsync? attributeDataSource;

  @override
  void initState() {
    super.initState();
    attributeNameController.text = widget.title;
    title = widget.title;
    _bloc.add(DetailAttributeStarted(context, widget.id));
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
        onSort: (columnIndex, ascending) => () {
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
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          children: [
            Text(
              title,
              style: AppStyles.bold.copyWith(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                _bloc.add(ProductAttributeUpdated(
                    context, attributeNameController.text.trim(), widget.id));
                setState(() {
                  title = attributeNameController.text.trim();
                });
                showSnackBar(
                  context,
                  'Save Changes',
                  const Icon(
                    Icons.check,
                  ),
                );
              },
              child: Text(
                'Save',
                style: AppStyles.medium.copyWith(
                  color: isActive ? AppColors.primary : AppColors.gray,
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _bloc.add(DetailAttributeStarted(context, widget.id));
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text('General Information', style: AppStyles.medium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFieldInput(
                    isEnabled: true,
                    hintText: 'Name Attribute',
                    controller: attributeNameController,
                    onChanged: (value) {
                      setState(() {
                        isActive = true;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attribute Values',
                        style: AppStyles.semibold,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (_) => AddAttributeValueDialog(
                              controller: TextEditingController(),
                            ),
                          );
                          if (result != null && result != '') {
                            _bloc.add(DetailAttributeAdded(
                                context, result, widget.id));
                          }
                        },
                        child: Text(
                          'Assign value',
                          style: AppStyles.medium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<DetailAttributeBloc, DetailAttributeState>(
                    builder: (context, state) {
                  if (state is DetailAttributeLoading) {
                    return LoadingScreen().showLoadingWidget();
                  } else if (state is DetailAttributeError) {
                    return _buildAttributeValueTable(attributeDataSource);
                  } else if (state is DetailAttributeLoaded) {
                    attributeDataSource = state.attributesDataSource;

                    return _buildAttributeValueTable(attributeDataSource);
                  }
                  return LoadingScreen().showLoadingWidget();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAttributeValueTable(
      AttributeValueDataSourceAsync? attributeDataSource) {
    return AttributeValuesTable(
      controller: _controller,
      columns: _columns,
      attributeValueDataSourceAsync: attributeDataSource,
      onPageChanged: (rowIndex) {
        int page = (rowIndex / _rowsPerPage).round();
        // _bloc.add(CategoriesPageChanged(
        //     page: page, limit: _rowsPerPage, context: context));
      },
      onRowsPerPageChanged: (value) {
        _rowsPerPage = value!;
        // _bloc.add(
        //   CategoriesPageChanged(
        //     page: 1,
        //     limit: value,
        //     context: context,
        //   ),
        // );
      },
      rowsPerPage: _rowsPerPage,
      sortAscending: sortAscending,
    );
  }
}
