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
