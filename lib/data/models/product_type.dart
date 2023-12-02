// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductType {
  final int id;
  final String name;
  final bool? selected;

  ProductType({
    required this.id,
    required this.name,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory ProductType.fromMap(Map<String, dynamic> map) {
    return ProductType(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
