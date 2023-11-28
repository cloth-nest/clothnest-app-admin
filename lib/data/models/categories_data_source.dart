import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/categories_data.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/presentation/screens/admin/category/edit_category_screen.dart';
import 'package:grocery/presentation/services/admin/categories_overview_bloc/categories_overview_bloc.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableCategorySelections extends RestorableProperty<Set<int>> {
  Set<int> _categorySelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _categorySelections.contains(index);

  /// Takes a list of [Dessert]s and saves the row indices of selected rows
  /// into a [Set].
  void setCategorySelections(List<Category> categoriesData) {
    final updatedSet = <int>{};
    for (var i = 0; i < categoriesData.length; i += 1) {
      var category = categoriesData[i];
      if (category.selected ?? false) {
        updatedSet.add(i);
      }
    }
    _categorySelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _categorySelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _categorySelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _categorySelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _categorySelections = value;
  }

  @override
  Object toPrimitives() => _categorySelections.toList();
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class CategoryDataSourceAsync extends AsyncDataTableSource {
  final CategoriesData categoriesData;
  final BuildContext context;

  CategoryDataSourceAsync({
    required this.categoriesData,
    required this.context,
  }) {
    debugPrint('CategoryDataSourceAsync created');
  }

  CategoryDataSourceAsync.empty(this.categoriesData, this.context) {
    _empty = true;
    debugPrint('CategoryDataSourceAsync.empty created');
  }

  CategoryDataSourceAsync.error(this.categoriesData, this.context) {
    _errorCounter = 0;
    debugPrint('CategoryDataSourceAsync.error created');
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

  int getTotalRecords() {
    return categoriesData.pageInformation.totalCount;
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

    var r = AsyncRowsResponse(
        categoriesData.categories.length,
        categoriesData.categories.map((category) {
          return DataRow(
            key: ValueKey<int>(category.id),
            selected: category.selected ?? false,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(category.id), value);
              }
            },
            cells: [
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    category.name,
                  ),
                ),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditCategoryScreen(category: category),
                    ),
                  );

                  context
                      .read<CategoriesOverviewBloc>()
                      .add(CategoriesOverviewFetched(context: context));
                },
              ),
              const DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '10',
                  ),
                ),
              ),
              const DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '12',
                  ),
                ),
              ),
            ],
          );
        }).toList());

    return r;
  }
}
