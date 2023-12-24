part of 'permission_bloc.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object> get props => [];
}

class PermissionInitital extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionError extends PermissionState {
  final String errorMessage;

  const PermissionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PermissionLoaded extends PermissionState {
  final PermissionDataSourceAsync permissionDataSourceAsync;
  final bool? isAdded;
  const PermissionLoaded(this.permissionDataSourceAsync, this.isAdded);

  @override
  List<Object> get props => [permissionDataSourceAsync];
}
