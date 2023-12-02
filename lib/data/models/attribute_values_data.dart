import 'package:grocery/data/models/attribute_value.dart';
import 'package:grocery/data/models/page_information.dart';

class AttributeValuesData {
  final List<AttributeValue> attributeValues;
  final PageInformation pageInformation;
  AttributeValuesData({
    required this.attributeValues,
    required this.pageInformation,
  });

  factory AttributeValuesData.fromMap(Map<String, dynamic> map) {
    return AttributeValuesData(
      attributeValues: List<AttributeValue>.from(
        (map['attributeValues']).map<AttributeValue>(
          (x) => AttributeValue.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
