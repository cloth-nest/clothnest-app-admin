import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/permissions_data.dart';
import 'package:grocery/data/repository/permission_repository.dart';
import 'package:grocery/data/repository/staff_member_repository.dart';

part 'invite_staff_event.dart';
part 'invite_staff_state.dart';

class InviteStaffBloc extends Bloc<InviteStaffEvent, InviteStaffState> {
  final PermissionRepository permissionRepository;
  final StaffMemberRepository staffMemberRepository;

  InviteStaffBloc(
    this.permissionRepository,
    this.staffMemberRepository,
  ) : super(InviteStaffLoading()) {
    on<InviteStaffInit>(_onInit);
  }

  FutureOr<void> _onInit(
      InviteStaffInit event, Emitter<InviteStaffState> emit) async {
    try {
      emit(InviteStaffLoading());

      PermissionsData? permissionsData =
          await permissionRepository.getPermissionData();
      List<GroupPermission> groupPermissions =
          permissionsData?.permissions ?? [];

      emit(InviteStaffInitial(groupPermissions: groupPermissions));
    } catch (e) {
      debugPrint('error on init invite staff: $e');
    }
  }
}
