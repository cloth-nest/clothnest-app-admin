import 'dart:convert';

import 'package:grocery/data/models/comment.dart';

class Review {
  final List<Comment> comments;
  final num rating;

  const Review({
    required this.comments,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comments': comments.map((x) => x.toMap()).toList(),
      'rating': rating,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      comments: map['commentList'].length == 0
          ? []
          : List<Comment>.from(
              (map['commentList']).map<Comment>(
                (x) => Comment.fromMap(x as Map<String, dynamic>),
              ),
            ),
      rating: map['ratingAverage'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);

  Review copyWith({
    List<Comment>? comments,
    double? rating,
  }) {
    return Review(
      comments: comments ?? this.comments,
      rating: rating ?? this.rating,
    );
  }
}
