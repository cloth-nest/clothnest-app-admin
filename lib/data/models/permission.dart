// ignore_for_file: public_member_api_docs, sort_constructors_first
class Permission {
  final int id;
  final String name;
  final int members;
  final bool? selected;

  Permission({
    required this.id,
    required this.name,
    required this.members,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'members': members,
    };
  }

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
      id: map['id'] as int,
      name: map['name'] as String,
      members: map['members'] as int,
    );
  }
}
