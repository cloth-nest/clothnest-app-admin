import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/permissions_data_source.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/permission/add_permission_group_screen.dart';
import 'package:grocery/presentation/screens/permission/components/permission_table.dart';
import 'package:grocery/presentation/services/bloc/permission_bloc.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  PermissionBloc get _bloc => BlocProvider.of<PermissionBloc>(context);

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;
  bool _sortAscending = true;
  PermissionDataSourceAsync? dataSourceAsync;

  void sort(
    bool ascending,
  ) {
    var columnName = "Permission Group Name";
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
          child: Text('Permission Group Name'),
        ),
        onSort: (columnIndex, ascending) => () {
          sort(ascending);
          setState(() {
            sortAscending = ascending;
          });
        },
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Members',
          ),
        ),
        onSort: (columnIndex, ascending) {},
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(PermissionStarted(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Permission Groups',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<PermissionBloc, PermissionState>(
        listener: (context, state) {},
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
                    'All Permission Groups',
                    style: AppStyles.semibold,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final isAdded = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddPermissionGroupScreen(),
                        ),
                      );
                      if (isAdded) {
                        _bloc.add(PermissionStarted(context));
                      }
                    },
                    child: Text(
                      'Create permission group',
                      style: AppStyles.medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<PermissionBloc, PermissionState>(
                builder: (context, state) {
              if (state is PermissionLoading) {
                return LoadingScreen().showLoadingWidget();
              } else if (state is PermissionError) {
                return Text(state.errorMessage);
              } else if (state is PermissionLoaded) {
                dataSourceAsync = state.permissionDataSourceAsync;
                PermissionDataSourceAsync? permissionDataSourceAsync =
                    state.permissionDataSourceAsync;

                return _buildPermissionTable(permissionDataSourceAsync);
              }
              return LoadingScreen().showLoadingWidget();
            })
          ],
        ),
      ),
    );
  }

  _buildPermissionTable(PermissionDataSourceAsync? permissionDataSourceAsync) {
    return PermissionsTable(
      controller: _controller,
      columns: _columns,
      permissionDataSourceAsync: permissionDataSourceAsync,
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
