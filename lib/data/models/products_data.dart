import 'package:grocery/data/models/page_information.dart';
import 'package:grocery/data/models/product.dart';

class ProductsData {
  final List<Product> products;
  final PageInformation pageInformation;

  ProductsData({
    required this.products,
    required this.pageInformation,
  });

  factory ProductsData.fromMap(Map<String, dynamic> map) {
    return ProductsData(
      products: List<Product>.from(
        (map['products']).map<Product>(
          (x) => Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
