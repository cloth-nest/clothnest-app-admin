import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/categories_data_source.dart';
import 'package:grocery/presentation/res/colors.dart';

class CategoriesTable extends StatelessWidget {
  final CategoryDataSourceAsync? categoryDataSource;
  final PaginatorController controller;
  final List<DataColumn> columns;
  final Function(int?) onRowsPerPageChanged;
  final Function(int) onPageChanged;

  const CategoriesTable({
    super.key,
    this.categoryDataSource,
    required this.controller,
    required this.columns,
    required this.onRowsPerPageChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AsyncPaginatedDataTable2(
            horizontalMargin: 20,
            checkboxHorizontalMargin: 5,
            columnSpacing: 20,
            wrapInCard: true,
            renderEmptyRowsInTheEnd: false,
            minWidth: 600,
            rowsPerPage: 10,
            fit: FlexFit.tight,
            border: const TableBorder(
              top: BorderSide(color: AppColors.gray),
              bottom: BorderSide(color: AppColors.gray),
              left: BorderSide(color: AppColors.gray),
              right: BorderSide(color: AppColors.gray),
              verticalInside: BorderSide(color: AppColors.gray),
              horizontalInside: BorderSide(color: AppColors.gray),
            ),
            onRowsPerPageChanged: (value) {
              onRowsPerPageChanged(value);
            },
            initialFirstRowIndex: 0,
            onPageChanged: (rowIndex) {
              onPageChanged(rowIndex);
            },
            // sortColumnIndex: _sortColumnIndex,
            // sortAscending: sortAscending,
            sortArrowIcon: Icons.keyboard_arrow_up,
            sortArrowAnimationDuration: const Duration(milliseconds: 0),
            // onSelectAll: (select) => select != null && select
            //     ? (getCurrentRouteOption(context) != selectAllPage
            //         ? _dessertsDataSource!.selectAll()
            //         : _dessertsDataSource!.selectAllOnThePage())
            //     : (getCurrentRouteOption(context) != selectAllPage
            //         ? _dessertsDataSource!.deselectAll()
            //         : _dessertsDataSource!.deselectAllOnThePage()),
            controller: controller,
            columns: columns,
            hidePaginator: false,
            empty: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey[200],
                child: const Text('No data'),
              ),
            ),
            source: categoryDataSource!,
          ),
        ],
      ),
    );
  }
}
