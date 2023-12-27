// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'invite_staff_bloc.dart';

abstract class InviteStaffState extends Equatable {
  const InviteStaffState();

  @override
  List<Object> get props => [];
}

class InviteStaffInitial extends InviteStaffState implements Equatable {
  final List<GroupPermission> groupPermissions;
  const InviteStaffInitial({
    required this.groupPermissions,
  });
  @override
  List<Object> get props => [groupPermissions];
}

class InviteStaffLoading extends InviteStaffState {}
