// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  final String name;
  final String? image;
  final int? id;
  final int level;

  Category({
    required this.name,
    this.image,
    this.id,
    required this.level,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'categoryImage': image,
      'id': id,
      'level': level,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map["name"] as String,
      image: map['categoryImage'],
      id: map['id'],
      level: map['level'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
