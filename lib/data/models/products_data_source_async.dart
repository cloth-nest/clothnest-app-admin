import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/data/models/products_data.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/screens/admin/product/add_detail_product_screen.dart';
import 'package:grocery/presentation/screens/admin/product/product_detail_screen.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableProductsSelections extends RestorableProperty<Set<int>> {
  Set<int> _productSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _productSelections.contains(index);

  void setProductsSelection(List<Product> productsData) {
    final updatedSet = <int>{};
    for (var i = 0; i < productsData.length; i += 1) {
      var staff = productsData[i];
      if (staff.selected ?? false) {
        updatedSet.add(i);
      }
    }
    _productSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _productSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _productSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _productSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _productSelections = value;
  }

  @override
  Object toPrimitives() => _productSelections.toList();
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class ProductDataSourceAsync extends AsyncDataTableSource {
  final ProductsData productsData;
  final BuildContext context;

  ProductDataSourceAsync({
    required this.productsData,
    required this.context,
  }) {
    debugPrint('ProductDataSourceAsync created');
  }

  ProductDataSourceAsync.empty(this.productsData, this.context) {
    _empty = true;
    debugPrint('ProductDataSourceAsync.empty created');
  }

  ProductDataSourceAsync.error(this.productsData, this.context) {
    _errorCounter = 0;
    debugPrint('ProductDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String _sortColumn = "Product";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  int Function(Product, Product)? _getComparisonFunction(bool ascending) {
    var coef = ascending ? 1 : -1;

    return (Product d1, Product d2) => coef * d1.name.compareTo(d2.name);
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    debugPrint('##debug: startIndex: $startIndex - count: $count');
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    assert(startIndex >= 0);

    await Future.delayed(const Duration(milliseconds: 400));

    List<Product> products = productsData.products;
    products.sort(_getComparisonFunction(_sortAscending));

    List<Product> result = products.skip(startIndex).take(count).toList();

    var r = AsyncRowsResponse(
        productsData.pageInformation.totalCount,
        result.map((product) {
          return DataRow(
            key: ValueKey<int>(product.id),
            selected: product.selected ?? false,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(product.id), value);
              }
            },
            cells: [
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        product.image ?? '',
                        width: 30,
                        height: 30,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 20,
                            height: 20,
                            color: AppColors.gray,
                          );
                        },
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                        product: product,
                      ),
                    ),
                  );
                },
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.productType,
                  ),
                ),
                onTap: () async {},
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.description,
                  ),
                ),
                onTap: () async {},
              ),
              DataCell(
                const SizedBox(
                  width: 50,
                ),
                showEditIcon: true,
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddDetailProductScreen(
                        product: product,
                      ),
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
