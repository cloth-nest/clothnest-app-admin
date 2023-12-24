import 'package:grocery/data/models/page_information.dart';
import 'package:grocery/data/models/product_type.dart';

class ProductTypesData {
  final List<ProductType> productTypes;
  final PageInformation pageInformation;
  ProductTypesData({
    required this.productTypes,
    required this.pageInformation,
  });

  factory ProductTypesData.fromMap(Map<String, dynamic> map) {
    return ProductTypesData(
      productTypes: List<ProductType>.from(
        (map['productTypes']).map<ProductType>(
          (x) => ProductType.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
