// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_staff_bloc.dart';

abstract class DetailStaffState extends Equatable {
  const DetailStaffState();

  @override
  List<Object> get props => [];
}

class DetailStaffInitial extends DetailStaffState {
  final Staff staff;
  final List<GroupPermission> groupPermissions;

  const DetailStaffInitial({
    required this.staff,
    required this.groupPermissions,
  });
}

class DetailStaffLoading extends DetailStaffState {}
