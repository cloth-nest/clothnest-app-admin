import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/permissions_data.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorablePermissionSelections extends RestorableProperty<Set<int>> {
  Set<int> _permissionSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _permissionSelections.contains(index);

  void setPermissionsSelection(List<GroupPermission> permissionsData) {
    final updatedSet = <int>{};
    for (var i = 0; i < permissionsData.length; i += 1) {
      var staff = permissionsData[i];
      if (staff.selected ?? false) {
        updatedSet.add(i);
      }
    }
    _permissionSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _permissionSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _permissionSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _permissionSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _permissionSelections = value;
  }

  @override
  Object toPrimitives() => _permissionSelections.toList();
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class PermissionDataSourceAsync extends AsyncDataTableSource {
  final PermissionsData permissionsData;
  final BuildContext context;

  PermissionDataSourceAsync({
    required this.permissionsData,
    required this.context,
  }) {
    debugPrint('PermissionDataSourceAsync created');
  }

  PermissionDataSourceAsync.empty(this.permissionsData, this.context) {
    _empty = true;
    debugPrint('PermissionDataSourceAsync.empty created');
  }

  PermissionDataSourceAsync.error(this.permissionsData, this.context) {
    _errorCounter = 0;
    debugPrint('PermissionDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String _sortColumn = "Permission Group Name";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  int Function(GroupPermission, GroupPermission)? _getComparisonFunction(
      bool ascending) {
    var coef = ascending ? 1 : -1;

    return (GroupPermission d1, GroupPermission d2) =>
        coef * d1.name.compareTo(d2.name);
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

    List<GroupPermission> result = permissionsData.permissions;
    result.sort(_getComparisonFunction(_sortAscending));

    List<GroupPermission> permissions =
        result.skip(startIndex).take(count).toList();

    var r = AsyncRowsResponse(
        permissionsData.pageInformation.totalCount,
        permissions.map((permission) {
          return DataRow(
            key: ValueKey<int>(permission.id),
            selected: permission.selected ?? false,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(permission.id), value);
              }
            },
            cells: [
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    permission.name,
                  ),
                ),
                onTap: () async {},
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    permission.members.toString(),
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
