import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/permissions_data.dart';
import 'package:grocery/data/models/staff.dart';
import 'package:grocery/data/repository/permission_repository.dart';
import 'package:grocery/data/repository/staff_member_repository.dart';

part 'detail_staff_event.dart';
part 'detail_staff_state.dart';

class DetailStaffBloc extends Bloc<DetailStaffEvent, DetailStaffState> {
  StaffMemberRepository _staffMemberRepository;
  PermissionRepository _permissionRepository;

  DetailStaffBloc(
    this._staffMemberRepository,
    this._permissionRepository,
  ) : super(DetailStaffLoading()) {
    on<DetailStaffStarted>((event, emit) async {
      emit(DetailStaffLoading());

      try {
        Staff? staff =
            await _staffMemberRepository.getStaffDetail(idStaff: event.idStaff);

        PermissionsData? permissionsData =
            await _permissionRepository.getPermissionData();
        List<GroupPermission> groupPermissions =
            permissionsData?.permissions ?? [];

        emit(
          DetailStaffInitial(
            staff: staff!,
            groupPermissions: groupPermissions,
          ),
        );
      } catch (e) {
        debugPrint('##detail staff started: $e');
      }
    });
  }
}
