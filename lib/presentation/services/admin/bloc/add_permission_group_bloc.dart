import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/permission.dart';
import 'package:grocery/data/repository/permission_repository.dart';

part 'add_permission_group_event.dart';
part 'add_permission_group_state.dart';

class AddPermissionGroupBloc
    extends Bloc<AddPermissionGroupEvent, AddPermissionGroupState> {
  final PermissionRepository permissionRepository;

  AddPermissionGroupBloc(this.permissionRepository)
      : super(AddPermissionLoading()) {
    on<AddPermissionInit>(_onInit);
    on<AddPermission>(_onAdded);
  }

  FutureOr<void> _onInit(
      AddPermissionInit event, Emitter<AddPermissionGroupState> emit) async {
    try {
      emit(AddPermissionLoading());

      List<Permission>? permissions =
          await permissionRepository.getPermissions();

      emit(AddPermissionInitial(permissions: permissions ?? []));
    } catch (e) {
      debugPrint('##error on init: $e');
    }
  }

  FutureOr<void> _onAdded(
      AddPermission event, Emitter<AddPermissionGroupState> emit) async {
    try {
      emit(AddPermissionLoading());

      await permissionRepository.addPermissionGroup(
        groupPermissionName: event.groupPermissionName,
        permissions: event.permissions,
      );

      emit(AddPermissionAdded());
    } catch (e) {
      debugPrint('##error on init: $e');
    }
  }
}
