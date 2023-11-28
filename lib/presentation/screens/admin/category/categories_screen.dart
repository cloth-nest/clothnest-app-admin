import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/categories_data_source.dart';
import 'package:grocery/data/models/category.dart' as c;
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/category/add_category_screen.dart';
import 'package:grocery/presentation/screens/admin/category/components/categories_table.dart';
import 'package:grocery/presentation/services/admin/categories_overview_bloc/categories_overview_bloc.dart';
import 'package:data_table_2/data_table_2.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController searchController = TextEditingController();
  CategoriesOverviewBloc get _bloc =>
      BlocProvider.of<CategoriesOverviewBloc>(context);

  bool sortAscending = true;
  final PaginatorController _controller = PaginatorController();
  int _rowsPerPage = 10;
  int initialRow = 0;

  final GlobalKey rangeSelectorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc.add(CategoriesOverviewFetched(context: context));
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: AppStyles.semibold,
                  ),
                  GestureDetector(
                    onTap: () => handleAddCategory(null),
                    child: Text(
                      'Create category',
                      style: AppStyles.medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //list categories
            BlocBuilder<CategoriesOverviewBloc, CategoriesOverviewState>(
              builder: (context, state) {
                if (state is CategoriesOverviewLoading) {
                  return LoadingScreen().showLoadingWidget();
                } else if (state is CategoriesOverviewFailure) {
                  return Text(state.errorMessage);
                } else if (state is CategoriesOverviewSuccess) {
                  CategoryDataSourceAsync? categoryDataSource =
                      state.categoryDataSource;

                  return _buildCategoryTable(categoryDataSource);
                }
                return LoadingScreen().showLoadingWidget();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Category name'),
        ),
        onSort: (columnIndex, ascending) => () {
          setState(() {});
        },
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Subcategories',
          ),
        ),
        onSort: (columnIndex, ascending) => () {
          setState(() {});
        },
      ),
      DataColumn(
        label: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Number of products'),
        ),
        onSort: (columnIndex, ascending) => () {
          setState(() {});
        },
      ),
    ];
  }

  _buildCategoryTable(CategoryDataSourceAsync? categoryDataSource) {
    return CategoriesTable(
      controller: _controller,
      columns: _columns,
      categoryDataSource: categoryDataSource,
      onPageChanged: (rowIndex) {
        int page = (rowIndex / _rowsPerPage).round();
        _bloc.add(CategoriesPageChanged(
            page: page, limit: _rowsPerPage, context: context));
      },
      onRowsPerPageChanged: (value) {
        _rowsPerPage = value!;
        _bloc.add(
          CategoriesPageChanged(
            page: 1,
            limit: value,
            context: context,
          ),
        );
      },
    );
  }

  handleAddCategory(int? parentId) async {
    final c.Category? newCategory = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddCategoryScreen(
          parentId: parentId,
        ),
      ),
    );

    if (newCategory != null) {
      _bloc.add(
        NewCategoryAdded(category: newCategory, context: context),
      );
    }
  }
}
