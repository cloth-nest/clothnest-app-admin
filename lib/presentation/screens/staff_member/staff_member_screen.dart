import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/staff_data_source.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/staff_member/components/invite_staff_member_dialog.dart';
import 'package:grocery/presentation/screens/staff_member/components/staff_member_table.dart';
import 'package:grocery/presentation/services/staff_member_bloc/staff_member_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
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
    final size = MediaQuery.of(context).size;

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
        listener: (context, state) {
          if (state is StaffMemberLoaded) {
            if (state.isAdded == true) {
              showSnackBar(
                context,
                'Invite staff successfully',
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              );
            }
            //return LoadingScreen().show(context: context);
          }
          //return LoadingScreen().hide();
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _bloc.add(StaffMemberStarted(context));
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
                          'All Staff Members',
                          style: AppStyles.semibold,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => const InviteStaffMemberDialog(),
                            );

                            if (result != null) {
                              String firstName = result[0];
                              String lastName = result[1];
                              String email = result[2];
                              bool isActive = result[3];
                              List<int> groupPermissionIds =
                                  (result[4] as List<GroupPermission>)
                                      .map((e) => e.id)
                                      .toList();

                              _bloc.add(StaffMemberAdded(
                                firstName,
                                lastName,
                                email,
                                isActive,
                                groupPermissionIds,
                                context,
                              ));
                            }
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
                      if (state.errorMessage == 'ForbiddenError') {
                        return Center(
                          child: Text(
                            'You don\'t have permission to see staffs',
                            style: AppStyles.medium.copyWith(color: Colors.red),
                          ),
                        );
                      }
                      return Center(
                        child: Text(state.errorMessage),
                      );
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
          ),
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
      },
      onRowsPerPageChanged: (value) {
        _rowsPerPage = value!;
      },
      rowsPerPage: _rowsPerPage,
      sortAscending: sortAscending,
    );
  }
}
