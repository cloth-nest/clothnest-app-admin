// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:grocery/data/models/comment.dart';
import 'package:grocery/data/models/product_image.dart';

class Product {
  final String? id;
  final int categoryId;
  final String productName;
  final List<ProductImage>? productImgList;
  final String unit;
  final int price;
  final int discount;
  final String productDescription;
  final String? thumbnail;
  final int? quantity;

  Product({
    this.id,
    required this.categoryId,
    required this.productName,
    this.productImgList,
    required this.unit,
    required this.price,
    required this.discount,
    required this.productDescription,
    this.thumbnail,
    this.quantity,
  });

  Product copyWith({
    String? id,
    int? categoryId,
    String? productName,
    List<ProductImage>? productImgList,
    String? unit,
    int? price,
    int? discount,
    String? productDescription,
    List<Comment>? comments,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      productName: productName ?? this.productName,
      productImgList: productImgList ?? this.productImgList,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      productDescription: productDescription ?? this.productDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'name': productName,
      'imageList': productImgList!.map((x) => x.toMap()).toList(),
      'unit': unit,
      'price': price,
      'discount': discount,
      'description': productDescription,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        quantity: map['quantity'] ?? -1,
        id: map['id'] != null ? map['id'] as String : null,
        categoryId: map['categoryId'] ?? -1,
        productName: map['productName'] as String,
        productImgList: map['productImgList'] != null
            ? List<ProductImage>.from(
                (map['productImgList']).map(
                  (x) => ProductImage.fromMap(x),
                ),
              )
            : [],
        unit: map['unit'] as String,
        price: map['price'] as int,
        discount: map['discount'] as int,
        productDescription: map['productDescription'] as String,
        thumbnail:
            map['thumbnail'] != null ? map['thumbnail'] as String : null);
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
