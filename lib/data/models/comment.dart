class Comment {
  final List<String> images;
  final String content;
  final double rating;
  final String createdAt;
  final String lastName;
  final String firstName;
  final String? avatar;

  Comment({
    required this.images,
    required this.content,
    required this.rating,
    required this.createdAt,
    required this.lastName,
    required this.firstName,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'images': images,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
      'lastName': lastName,
      'firstName': firstName,
      'avatar': avatar,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      images: (map['images'] as List).map((e) => e['image'] as String).toList(),
      content: map['content'] as String,
      rating: map['rating'] * 1.0 ?? 1.0,
      createdAt: map['createdAt'] as String,
      lastName: map['user']['lastName'] as String,
      firstName: map['user']['firstName'] as String,
      avatar: map['user']['avatar'] != null
          ? map['user']['avatar'] as String
          : null,
    );
  }
}
