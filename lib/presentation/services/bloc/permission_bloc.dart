import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/permission.dart';
import 'package:grocery/data/models/permissions_data.dart';
import 'package:grocery/data/models/permissions_data_source.dart';
import 'package:grocery/data/repository/permission_repository.dart';
import 'package:grocery/presentation/utils/functions.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  // resource
  late PermissionRepository permissionRepository;

  // Data
  PermissionsData? permissionsData;

  PermissionBloc(this.permissionRepository) : super(PermissionInitital()) {
    on<PermissionStarted>(_onStarted);
    on<PermissionDeleted>(_onDeleted);
    on<DetailGroupPermissionUpdated>(_onUpdated);
  }

  FutureOr<void> _onStarted(
      PermissionStarted event, Emitter<PermissionState> emit) async {
    emit(PermissionLoading());
    try {
      PermissionsData? permissionsData =
          await permissionRepository.getPermissionData();
      PermissionDataSourceAsync permissionsDataSourceAsync =
          PermissionDataSourceAsync(
        permissionsData: permissionsData!,
        context: event.context,
      );
      emit(PermissionLoaded(permissionsDataSourceAsync, null));
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  FutureOr<void> _onDeleted(
      PermissionDeleted event, Emitter<PermissionState> emit) async {
    emit(PermissionLoading());
    try {
      await permissionRepository.deletePermissionGroup(
          idGroupPermission: event.idGroupPermission);
      PermissionsData? permissionsData =
          await permissionRepository.getPermissionData();
      PermissionDataSourceAsync permissionsDataSourceAsync =
          PermissionDataSourceAsync(
        permissionsData: permissionsData!,
        context: event.context,
      );
      emit(PermissionLoaded(permissionsDataSourceAsync, null));
    } catch (e) {
      showSnackBar(
        event.context,
        'Group permission is using',
        const Icon(Icons.error_outline),
      );
      emit(PermissionError(e.toString()));
    }
  }

  FutureOr<void> _onUpdated(
      DetailGroupPermissionUpdated event, Emitter<PermissionState> emit) async {
    emit(PermissionLoading());
    try {
      await permissionRepository.updatePermissionGroup(
        idGroupPermission: event.idGroupPermission,
        groupPermissionName: event.groupPermissionName,
        permissions: event.permissions,
      );
      PermissionsData? permissionsData =
          await permissionRepository.getPermissionData();
      PermissionDataSourceAsync permissionsDataSourceAsync =
          PermissionDataSourceAsync(
        permissionsData: permissionsData!,
        context: event.context,
      );
      emit(PermissionLoaded(permissionsDataSourceAsync, null));
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }
}
