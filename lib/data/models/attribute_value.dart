// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttributeValue {
  final int id;
  final String value;
  final bool? selected;

  AttributeValue({
    required this.id,
    required this.value,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
    };
  }

  factory AttributeValue.fromMap(Map<String, dynamic> map) {
    return AttributeValue(
      id: map['id'] as int,
      value: map['value'] as String,
    );
  }
}
