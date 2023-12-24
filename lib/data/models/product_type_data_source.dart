import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/data/models/product_types_data.dart';
import 'package:grocery/presentation/screens/product_type/detail_product_type_screen.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableProductTypeSelections extends RestorableProperty<Set<int>> {
  Set<int> _productTypeSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _productTypeSelections.contains(index);

  void setProductTypeSelections(List<ProductType> productTypesData) {
    final updatedSet = <int>{};
    for (var i = 0; i < productTypesData.length; i += 1) {
      var attribute = productTypesData[i];
      if (attribute.selected ?? false) {
        updatedSet.add(i);
      }
    }
    _productTypeSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _productTypeSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _productTypeSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _productTypeSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _productTypeSelections = value;
  }

  @override
  Object toPrimitives() => _productTypeSelections.toList();
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class ProductTypeDataSourceAsync extends AsyncDataTableSource {
  final ProductTypesData productTypesData;
  final BuildContext context;

  ProductTypeDataSourceAsync({
    required this.productTypesData,
    required this.context,
  }) {
    debugPrint('ProductTypeDataSourceAsync created');
  }

  ProductTypeDataSourceAsync.empty(this.productTypesData, this.context) {
    _empty = true;
    debugPrint('ProductTypeDataSourceAsync.empty created');
  }

  ProductTypeDataSourceAsync.error(this.productTypesData, this.context) {
    _errorCounter = 0;
    debugPrint('ProductTypeDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String _sortColumn = "Product Type";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  int Function(ProductType, ProductType)? _getComparisonFunction(
      bool ascending) {
    var coef = ascending ? 1 : -1;

    return (ProductType d1, ProductType d2) =>
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

    List<ProductType> productTypes = productTypesData.productTypes;
    productTypes.sort(_getComparisonFunction(_sortAscending));

    productTypes.skip(startIndex).take(count).toList();

    var r = AsyncRowsResponse(
        productTypesData.pageInformation.totalCount,
        productTypes.map((attribute) {
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
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailProductTypeScreen(productType: attribute),
                    ),
                  );
                },
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    attribute.name,
                  ),
                ),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailProductTypeScreen(productType: attribute),
                    ),
                  );
                },
              ),
            ],
          );
        }).toList());

    return r;
  }
}

class ProductTypeDataSourceAsync2 extends AsyncDataTableSource {
  final List<ProductType> productTypes;
  final BuildContext context;

  ProductTypeDataSourceAsync2({
    required this.productTypes,
    required this.context,
  }) {
    debugPrint('ProductTypeDataSourceAsync created');
  }

  ProductTypeDataSourceAsync2.empty(this.productTypes, this.context) {
    _empty = true;
    debugPrint('ProductTypeDataSourceAsync.empty created');
  }

  ProductTypeDataSourceAsync2.error(this.productTypes, this.context) {
    _errorCounter = 0;
    debugPrint('ProductTypeDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String _sortColumn = "Product Type";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  int Function(ProductType, ProductType)? _getComparisonFunction(
      bool ascending) {
    var coef = ascending ? 1 : -1;

    return (ProductType d1, ProductType d2) =>
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

    productTypes.sort(_getComparisonFunction(_sortAscending));

    productTypes.skip(startIndex).take(count).toList();

    var r = AsyncRowsResponse(
        productTypes.length,
        productTypes.map((attribute) {
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
                    attribute.name,
                  ),
                ),
              ),
            ],
          );
        }).toList());

    return r;
  }
}
