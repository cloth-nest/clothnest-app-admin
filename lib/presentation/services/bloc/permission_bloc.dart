import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/permissions_data.dart';
import 'package:grocery/data/models/permissions_data_source.dart';
import 'package:grocery/data/repository/permission_repository.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  // resource
  late PermissionRepository permissionRepository;

  // Data
  PermissionsData? permissionsData;

  PermissionBloc(this.permissionRepository) : super(PermissionInitital()) {
    on<PermissionStarted>(_onStarted);
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
}
