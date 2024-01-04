// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:grocery/data/models/product_image.dart';
import 'package:grocery/data/models/product_type.dart';

class DetailProduct {
  final int id;
  final String name;
  final String description;
  final List<ProductImage> productImages;
  final ProductType productType;
  final int variantId;
  final double price;
  final bool? selected;

  DetailProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.productImages,
    required this.productType,
    required this.variantId,
    required this.price,
    this.selected,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'productImages': productImages.map((x) => x.toMap()).toList(),
      'productType': productType.toMap(),
      'selected': selected,
    };
  }

  factory DetailProduct.fromMap(Map<String, dynamic> map) {
    return DetailProduct(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      productImages: List<ProductImage>.from(
        (map['productImages']).map<ProductImage>(
          (x) => ProductImage.fromMap(x as Map<String, dynamic>),
        ),
      ),
      productType:
          ProductType.fromMap(map['productType'] as Map<String, dynamic>),
      selected: map['selected'] != null ? map['selected'] as bool : null,
      variantId: (map['productVariants'] as List).isEmpty
          ? 1
          : map['productVariants'][0]['id'] ?? -1,
      price: (map['productVariants'] as List).isEmpty
          ? 0.0
          : map['productVariants'][0]['price'] * 1.0 ?? 1.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailProduct.fromJson(String source) =>
      DetailProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
