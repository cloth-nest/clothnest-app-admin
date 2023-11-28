// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  final int id;
  final String name;
  final int level;
  final String? bgImgUrl;
  final bool? selected;

  Category({
    required this.id,
    required this.name,
    required this.level,
    this.bgImgUrl,
    this.selected = false,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'] as String,
      bgImgUrl: map['bgImgUrl'],
      level: map['level'],
    );
  }
}
