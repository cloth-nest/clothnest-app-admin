import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductImage {
  final int? id;
  final String? productId;
  final String imgUrl;
  final int index;

  ProductImage({
    this.id,
    this.productId,
    required this.imgUrl,
    required this.index,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgUrl': imgUrl,
      'index': index,
    };
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      id: map['id'] ?? -1,
      imgUrl: map['image'] ?? '',
      index: map['order'] ?? -1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductImage.fromJson(String source) =>
      ProductImage.fromMap(json.decode(source) as Map<String, dynamic>);

  ProductImage copyWith({
    int? id,
    String? productId,
    String? imgUrl,
    int? index,
  }) {
    return ProductImage(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      imgUrl: imgUrl ?? this.imgUrl,
      index: index ?? this.index,
    );
  }
}
