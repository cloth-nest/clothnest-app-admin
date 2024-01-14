// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_group_permission_bloc.dart';

abstract class DetailGroupPermissionState extends Equatable {
  const DetailGroupPermissionState();

  @override
  List<Object> get props => [];
}

class DetailGroupPermissionInitial extends DetailGroupPermissionState {
  final List<Permission> permissions;
  final String groupName;
  final List<Permission> selectedpermissions;

  const DetailGroupPermissionInitial({
    required this.permissions,
    required this.groupName,
    required this.selectedpermissions,
  });
}

class DetailGroupPermissionLoading extends DetailGroupPermissionState {}

class DetailGroupPermissionError extends DetailGroupPermissionState {}
