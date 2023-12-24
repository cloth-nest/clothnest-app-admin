import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/staff_data_source.dart';
import 'package:grocery/data/models/staffs_data.dart';
import 'package:grocery/data/repository/staff_member_repository.dart';

part 'staff_member_event.dart';
part 'staff_member_state.dart';

class StaffMemberBloc extends Bloc<StaffMemberEvent, StaffMemberState> {
  // resource
  late StaffMemberRepository staffMemberRepository;

  // Data
  StaffsData? staffsData;

  StaffMemberBloc(this.staffMemberRepository) : super(StaffMemberInitital()) {
    on<StaffMemberStarted>(_onStarted);
  }

  FutureOr<void> _onStarted(
      StaffMemberStarted event, Emitter<StaffMemberState> emit) async {
    emit(StaffMemberLoading());
    try {
      StaffsData? staffsData = await staffMemberRepository.getStaffMemberData();
      StaffDataSourceAsync staffsDataSourceAsync = StaffDataSourceAsync(
        staffsData: staffsData!,
        context: event.context,
      );
      emit(StaffMemberLoaded(staffsDataSourceAsync, null));
    } catch (e) {
      emit(StaffMemberError(e.toString()));
    }
  }
}
