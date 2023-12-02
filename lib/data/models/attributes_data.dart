import 'package:grocery/data/models/attribute.dart';
import 'package:grocery/data/models/page_information.dart';

class AttributesData {
  final List<Attribute> attributes;
  final PageInformation pageInformation;
  AttributesData({
    required this.attributes,
    required this.pageInformation,
  });

  factory AttributesData.fromMap(Map<String, dynamic> map) {
    return AttributesData(
      attributes: List<Attribute>.from(
        (map['productAttributes']).map<Attribute>(
          (x) => Attribute.fromMap(x as Map<String, dynamic>),
        ),
      ),
      pageInformation: PageInformation.fromMap(
          map['pageInformation'] as Map<String, dynamic>),
    );
  }
}
