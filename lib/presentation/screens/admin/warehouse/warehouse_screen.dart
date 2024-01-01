import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/staff_data_source.dart';
import 'package:grocery/data/models/warehouse_data_source_async.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/warehouse/components/add_warehouse_dialog.dart';
import 'package:grocery/presentation/screens/admin/warehouse/warehouse_table.dart';
import 'package:grocery/presentation/services/bloc/warehouse_bloc.dart';

import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({super.key});

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  WarehouseBloc get _bloc => BlocProvider.of<WarehouseBloc>(context);

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;
  bool _sortAscending = true;
  WarehouseDataSourceAsync? dataSourceAsync;

  void sort(
    bool ascending,
  ) {
    var columnName = "Email Address";
    dataSourceAsync?.sort(columnName, ascending);
    setState(() {
      _sortAscending = ascending;
    });
  }

  List<DataColumn> get _columns {
    return [
      DataColumn2(
        fixedWidth: 40,
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
            'Name',
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
    _bloc.add(WarehouseStarted(context: context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Warehouses',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<WarehouseBloc, WarehouseState>(
        listener: (context, state) {},
        child: RefreshIndicator(
          onRefresh: () async {
            _bloc.add(WarehouseStarted(context: context));
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
                          'All Warehouses',
                          style: AppStyles.semibold,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => AddWarehouseDialog(
                                controller: TextEditingController(),
                              ),
                            );

                            if (result != null) {
                              _bloc.add(
                                WarehouseAdded(
                                  context: context,
                                  warehouseName: result,
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Create Warehouse',
                            style: AppStyles.medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<WarehouseBloc, WarehouseState>(
                      builder: (context, state) {
                    if (state is WarehouseLoading) {
                      return LoadingScreen().showLoadingWidget();
                    } else if (state is WarehouseInitial) {
                      WarehouseDataSourceAsync? warehouseDataSourceAsync =
                          WarehouseDataSourceAsync(
                              warehouses: state.warehouses, context: context);

                      return _buildWarehouseTable(warehouseDataSourceAsync);
                    } else if (state is WarehouseFailure) {
                      if (state.errorMessage == 'ForbiddenError') {
                        return Center(
                          child: Text(
                            'You don\'t have permission to see warehouses',
                            style: AppStyles.medium.copyWith(color: Colors.red),
                          ),
                        );
                      }
                      return Center(
                        child: Text(state.errorMessage),
                      );
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

  _buildWarehouseTable(WarehouseDataSourceAsync? warehouseDataSourceAsync) {
    return WarehousesTable(
      controller: _controller,
      columns: _columns,
      warehouseDataSourceAsync: warehouseDataSourceAsync,
      onPageChanged: (rowIndex) {},
      onRowsPerPageChanged: (value) {
        _rowsPerPage = value!;
      },
      rowsPerPage: _rowsPerPage,
      sortAscending: sortAscending,
    );
  }
}
