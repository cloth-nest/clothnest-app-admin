// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final int id;
  final String name;
  final int groupPermissionsCount;
  final bool? selected;

  Permission({
    required this.id,
    required this.name,
    required this.groupPermissionsCount,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'groupPermissionsCount': groupPermissionsCount,
    };
  }

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
      id: map['id'] as int,
      name: map['name'] as String,
      groupPermissionsCount: map['groupPermissionsCount'] as int,
    );
  }

  Permission copyWith({
    int? id,
    String? name,
    int? groupPermissionsCount,
    bool? selected,
  }) {
    return Permission(
      id: id ?? this.id,
      name: name ?? this.name,
      groupPermissionsCount:
          groupPermissionsCount ?? this.groupPermissionsCount,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [id];
}
