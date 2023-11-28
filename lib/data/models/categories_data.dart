import 'package:grocery/data/models/category.dart';
import 'package:grocery/data/models/page_information.dart';

class CategoriesData {
  final List<Category> categories;
  final PageInformation pageInformation;
  CategoriesData({
    required this.categories,
    required this.pageInformation,
  });

  factory CategoriesData.fromMap(Map<String, dynamic> map) {
    return CategoriesData(
      categories: List<Category>.from(
        (map['categories']).map<Category>(
          (x) => Category.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
