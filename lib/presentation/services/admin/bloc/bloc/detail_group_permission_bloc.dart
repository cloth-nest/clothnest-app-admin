import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/permission.dart';
import 'package:grocery/data/repository/permission_repository.dart';

part 'detail_group_permission_event.dart';
part 'detail_group_permission_state.dart';

class DetailGroupPermissionBloc
    extends Bloc<DetailGroupPermissionEvent, DetailGroupPermissionState> {
  final PermissionRepository permissionRepository;

  DetailGroupPermissionBloc(
    this.permissionRepository,
  ) : super(DetailGroupPermissionLoading()) {
    on<DetailGroupPermissionStarted>((event, emit) async {
      try {
        emit(DetailGroupPermissionLoading());

        GroupPermission? groupPermission =
            await permissionRepository.getDetailPermissionGroup(
                idGroupPermission: event.idGroupPermission);

        List<Permission>? permissions =
            await permissionRepository.getPermissions() ?? [];

        List<Permission> selectedPermissions = [];

        for (Permission permission in groupPermission!.groupPermissions!) {
          if (permissions.contains(permission)) {
            selectedPermissions.add(permission);
          }
        }

        emit(
          DetailGroupPermissionInitial(
            permissions: permissions,
            groupName: groupPermission.name,
            selectedpermissions: selectedPermissions,
          ),
        );
      } catch (e) {
        emit(DetailGroupPermissionError());
      }
    });
  }
}
