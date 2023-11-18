// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  final String name;
  final String image;
  final int? id;

  Category({
    required this.name,
    required this.image,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryName': name,
      'categoryImage': image,
      'id': id,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map["categoryName"] as String,
      image: map['categoryImage'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
