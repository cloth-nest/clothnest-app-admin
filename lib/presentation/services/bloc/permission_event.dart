part of 'permission_bloc.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class PermissionStarted extends PermissionEvent {
  final BuildContext context;

  const PermissionStarted(this.context);
}

class PermissionDeleted extends PermissionEvent {
  final BuildContext context;
  final int idGroupPermission;

  const PermissionDeleted(
    this.context,
    this.idGroupPermission,
  );
}

class DetailGroupPermissionUpdated extends PermissionEvent {
  final BuildContext context;

  final String groupPermissionName;
  final List<int> permissions;
  final int idGroupPermission;

  const DetailGroupPermissionUpdated({
    required this.context,
    required this.groupPermissionName,
    required this.permissions,
    required this.idGroupPermission,
  });
}
