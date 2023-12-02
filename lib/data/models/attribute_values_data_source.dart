import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/attribute_value.dart';
import 'package:grocery/data/models/attribute_values_data.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableAttributeValuesSelections extends RestorableProperty<Set<int>> {
  Set<int> _attributeSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _attributeSelections.contains(index);

  void setAttributeSelections(List<AttributeValue> attributesData) {
    final updatedSet = <int>{};
    for (var i = 0; i < attributesData.length; i += 1) {
      var attribute = attributesData[i];
      if (attribute.selected ?? false) {
        updatedSet.add(i);
      }
    }
    _attributeSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _attributeSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _attributeSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _attributeSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _attributeSelections = value;
  }

  @override
  Object toPrimitives() => _attributeSelections.toList();
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class AttributeValueDataSourceAsync extends AsyncDataTableSource {
  final AttributeValuesData attributesData;
  final BuildContext context;

  AttributeValueDataSourceAsync({
    required this.attributesData,
    required this.context,
  }) {
    debugPrint('AttributeDataSourceAsync created');
  }

  AttributeValueDataSourceAsync.empty(this.attributesData, this.context) {
    _empty = true;
    debugPrint('AttributeDataSourceAsync.empty created');
  }

  AttributeValueDataSourceAsync.error(this.attributesData, this.context) {
    _errorCounter = 0;
    debugPrint('AttributeDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String _sortColumn = "name";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
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

    List<AttributeValue> attributes =
        attributesData.attributeValues.skip(startIndex).take(count).toList();

    var r = AsyncRowsResponse(
        attributesData.pageInformation.totalCount,
        attributes.map((attribute) {
          return DataRow(
            key: ValueKey<int>(attribute.id),
            selected: attribute.selected ?? false,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(attribute.id), value);
              }
            },
            cells: [
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    attribute.id.toString(),
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    attribute.value,
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
