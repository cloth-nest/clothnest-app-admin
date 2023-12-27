// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_permission_group_bloc.dart';

abstract class AddPermissionGroupEvent extends Equatable {
  const AddPermissionGroupEvent();

  @override
  List<Object> get props => [];
}

class AddPermissionInit extends AddPermissionGroupEvent {}

class AddPermission extends AddPermissionGroupEvent {
  final String groupPermissionName;
  final List<Permission> permissions;

  const AddPermission({
    required this.groupPermissionName,
    required this.permissions,
  });
}
