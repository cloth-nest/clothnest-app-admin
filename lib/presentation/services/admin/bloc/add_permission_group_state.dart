part of 'add_permission_group_bloc.dart';

abstract class AddPermissionGroupState extends Equatable {
  const AddPermissionGroupState();

  @override
  List<Object> get props => [];
}

class AddPermissionInitial extends AddPermissionGroupState {
  final List<Permission> permissions;

  const AddPermissionInitial({required this.permissions});
}

class AddPermissionLoading extends AddPermissionGroupState {}

class AddPermissionAdded extends AddPermissionGroupState {}
