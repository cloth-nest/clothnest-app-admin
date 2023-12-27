// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupPermission {
  final int id;
  final String name;
  final int members;
  final bool? selected;

  GroupPermission({
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

  factory GroupPermission.fromMap(Map<String, dynamic> map) {
    return GroupPermission(
      id: map['id'] as int,
      name: map['name'] as String,
      members: map['members'] as int,
    );
  }

  GroupPermission copyWith({
    int? id,
    String? name,
    int? members,
    bool? selected,
  }) {
    return GroupPermission(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      selected: selected ?? this.selected,
    );
  }
}
