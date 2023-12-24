// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String description;
  final String? image;
  final String productType;
  final bool? selected;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.productType,
    this.selected = false,
  });

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? productType,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      productType: productType ?? this.productType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'productType': productType,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'],
      productType: map['productType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
