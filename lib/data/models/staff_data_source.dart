import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/staff.dart';
import 'package:grocery/data/models/staffs_data.dart';
import 'package:grocery/presentation/screens/staff_member/components/detail_staff_member_dialog.dart';
import 'package:grocery/presentation/services/staff_member_bloc/staff_member_bloc.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableStaffSelections extends RestorableProperty<Set<int>> {
  Set<int> _staffSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _staffSelections.contains(index);

  void setStaffSelection(List<Staff> staffsData) {
    final updatedSet = <int>{};
    for (var i = 0; i < staffsData.length; i += 1) {
      var staff = staffsData[i];
      if (staff.selected ?? false) {
        updatedSet.add(i);
      }
    }
    _staffSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _staffSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _staffSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _staffSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _staffSelections = value;
  }

  @override
  Object toPrimitives() => _staffSelections.toList();
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class StaffDataSourceAsync extends AsyncDataTableSource {
  final StaffsData staffsData;
  final BuildContext context;

  StaffDataSourceAsync({
    required this.staffsData,
    required this.context,
  }) {
    debugPrint('StaffDataSourceAsync created');
  }

  StaffDataSourceAsync.empty(this.staffsData, this.context) {
    _empty = true;
    debugPrint('StaffDataSourceAsync.empty created');
  }

  StaffDataSourceAsync.error(this.staffsData, this.context) {
    _errorCounter = 0;
    debugPrint('StaffDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String _sortColumn = "Email Address";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  int Function(Staff, Staff)? _getComparisonFunction(bool ascending) {
    var coef = ascending ? 1 : -1;

    return (Staff d1, Staff d2) => coef * d1.email.compareTo(d2.email);
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    assert(startIndex >= 0);

    await Future.delayed(const Duration(milliseconds: 400));

    List<Staff> staffs = staffsData.staffs;
    staffs.sort(_getComparisonFunction(_sortAscending));

    staffs.skip(startIndex).take(count).toList();

    var r = AsyncRowsResponse(
        staffsData.pageInformation.totalCount,
        staffs.map((staff) {
          return DataRow(
            key: ValueKey<int>(staff.id),
            selected: staff.selected ?? false,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(staff.id), value);
              }
            },
            cells: [
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${staff.firstName} ${staff.lastName}',
                  ),
                ),
                onTap: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => DetailStaffMemberDialog(
                      idStaff: staff.id,
                    ),
                  );
                  if (result != null) {
                    bool isActive = result[3];
                    List<int> groupPermissionIds =
                        (result[4] as List<GroupPermission>)
                            .map((e) => e.id)
                            .toList();

                    context.read<StaffMemberBloc>().add(
                          StaffMemberUpdated(
                            staff.id,
                            isActive,
                            groupPermissionIds,
                            context,
                          ),
                        );
                  }
                },
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    staff.isActive ? 'Active' : 'Not active',
                  ),
                ),
                onTap: () async {},
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    staff.email,
                  ),
                ),
                onTap: () async {},
              ),
            ],
          );
        }).toList());

    return r;
  }
}
