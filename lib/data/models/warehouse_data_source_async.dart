import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/staff.dart';
import 'package:grocery/data/models/warehouse.dart';
import 'package:grocery/presentation/screens/admin/warehouse/components/detail_warehouse_dialog.dart';
import 'package:grocery/presentation/services/bloc/warehouse_bloc.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableWarehouseSelections extends RestorableProperty<Set<int>> {
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
class WarehouseDataSourceAsync extends AsyncDataTableSource {
  final List<Warehouse> warehouses;
  final BuildContext context;

  WarehouseDataSourceAsync({
    required this.warehouses,
    required this.context,
  }) {
    debugPrint('WarehouseDataSourceAsync created');
  }

  WarehouseDataSourceAsync.empty(this.warehouses, this.context) {
    _empty = true;
    debugPrint('WarehouseDataSourceAsync.empty created');
  }

  WarehouseDataSourceAsync.error(this.warehouses, this.context) {
    _errorCounter = 0;
    debugPrint('WarehouseDataSourceAsync.error created');
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

  int Function(Warehouse, Warehouse)? _getComparisonFunction(bool ascending) {
    var coef = ascending ? 1 : -1;

    return (Warehouse d1, Warehouse d2) => coef * d1.id.compareTo(d2.id);
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

    List<Warehouse> staffs = [...warehouses];
    staffs.sort(_getComparisonFunction(_sortAscending));

    List<Warehouse> results = staffs.skip(startIndex).take(count).toList();

    var r = AsyncRowsResponse(
        warehouses.length,
        results.map((staff) {
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
                    staff.id.toString(),
                  ),
                ),
                onTap: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => DetailWarehouseDialog(
                      controller: TextEditingController(),
                      warehouse: staff.name,
                    ),
                  );

                  if (result != null) {
                    context.read<WarehouseBloc>().add(
                          WarehouseUpdated(
                            context: context,
                            warehouseName: result,
                            idWarehouse: staff.id,
                          ),
                        );
                  }
                },
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    staff.name,
                  ),
                ),
                onTap: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => DetailWarehouseDialog(
                      controller: TextEditingController(),
                      warehouse: staff.name,
                    ),
                  );

                  if (result != null) {
                    context.read<WarehouseBloc>().add(
                          WarehouseUpdated(
                            context: context,
                            warehouseName: result,
                            idWarehouse: staff.id,
                          ),
                        );
                  }
                },
              ),
              DataCell(
                const Row(
                  children: [
                    SizedBox(width: 13),
                    Icon(Icons.delete),
                  ],
                ),
                onTap: () async {
                  context.read<WarehouseBloc>().add(WarehouseDeleted(
                        context: context,
                        idWarehouse: staff.id,
                      ));
                },
              ),
            ],
          );
        }).toList());

    return r;
  }
}
