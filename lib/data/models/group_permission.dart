// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:grocery/data/models/permission.dart';

class GroupPermission extends Equatable {
  final int id;
  final String name;
  final int members;
  final bool? selected;
  final List<Permission>? groupPermissions;

  GroupPermission({
    required this.id,
    required this.name,
    required this.members,
    this.selected = false,
    this.groupPermissions,
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
      members: map['members'] ?? 0,
      groupPermissions: map['groupPermissions'] != null
          ? (map['groupPermissions'] as List)
              .map((e) => Permission.fromMap(e))
              .toList()
          : null,
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

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
