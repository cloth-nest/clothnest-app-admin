import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/staff_data_source.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/staff_member/components/staff_member_table.dart';
import 'package:grocery/presentation/services/staff_member_bloc/staff_member_bloc.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class StaffMemberScreen extends StatefulWidget {
  const StaffMemberScreen({super.key});

  @override
  State<StaffMemberScreen> createState() => _StaffMemberScreenState();
}

class _StaffMemberScreenState extends State<StaffMemberScreen> {
  StaffMemberBloc get _bloc => BlocProvider.of<StaffMemberBloc>(context);

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;
  bool _sortAscending = true;
  StaffDataSourceAsync? dataSourceAsync;

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
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Name'),
        ),
        onSort: (columnIndex, ascending) => () {},
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Active',
          ),
        ),
        onSort: (columnIndex, ascending) {
          // sort(ascending);
          // setState(() {
          //   sortAscending = ascending;
          // });
        },
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Email Address',
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
    _bloc.add(StaffMemberStarted(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Staff Members',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<StaffMemberBloc, StaffMemberState>(
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
                    'All Staff Members',
                    style: AppStyles.semibold,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // final result = await showDialog(
                      //   context: context,
                      //   builder: (_) => AddProductAttributeDialog(
                      //     controller: TextEditingController(),
                      //   ),
                      // );
                    },
                    child: Text(
                      'Invite staff member',
                      style: AppStyles.medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<StaffMemberBloc, StaffMemberState>(
                builder: (context, state) {
              if (state is StaffMemberLoading) {
                return LoadingScreen().showLoadingWidget();
              } else if (state is StaffMemberError) {
                return Text(state.errorMessage);
              } else if (state is StaffMemberLoaded) {
                dataSourceAsync = state.staffDataSourceAsync;
                StaffDataSourceAsync? staffDataSourceAsync =
                    state.staffDataSourceAsync;

                return _buildStaffMemberTable(staffDataSourceAsync);
              }
              return LoadingScreen().showLoadingWidget();
            })
          ],
        ),
      ),
    );
  }

  _buildStaffMemberTable(StaffDataSourceAsync? staffDataSourceAsync) {
    return StaffMembersTable(
      controller: _controller,
      columns: _columns,
      staffDataSourceAsync: staffDataSourceAsync,
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