import 'dart:convert';

class Comment {
  final String content;
  final String productId;
  final String? image;
  final num rating;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? createdAt;

  Comment({
    required this.content,
    required this.productId,
    required this.image,
    required this.rating,
    this.firstName,
    this.lastName,
    this.avatar,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'productId': productId,
      'image': image,
      'rating': rating,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      content: map['content'] as String,
      productId: map['productId'] as String,
      image: map['image'],
      rating: map['rating'],
      firstName: map['user']['firstName'],
      lastName: map['user']['lastName'],
      avatar: map['user']['avatar'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  Comment copyWith({
    String? content,
    String? productId,
    String? image,
    double? rating,
  }) {
    return Comment(
      content: content ?? this.content,
      productId: productId ?? this.productId,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }
}
