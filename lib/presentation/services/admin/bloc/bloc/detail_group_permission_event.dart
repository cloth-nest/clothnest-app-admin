// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_group_permission_bloc.dart';

abstract class DetailGroupPermissionEvent extends Equatable {
  const DetailGroupPermissionEvent();

  @override
  List<Object> get props => [];
}

class DetailGroupPermissionStarted extends DetailGroupPermissionEvent {
  final int idGroupPermission;

  const DetailGroupPermissionStarted({
    required this.idGroupPermission,
  });
}
