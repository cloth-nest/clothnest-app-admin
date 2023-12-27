// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'staff_member_bloc.dart';

abstract class StaffMemberEvent extends Equatable {
  const StaffMemberEvent();

  @override
  List<Object> get props => [];
}

class StaffMemberStarted extends StaffMemberEvent {
  final BuildContext context;

  const StaffMemberStarted(this.context);
}

class StaffMemberAdded extends StaffMemberEvent {
  final String firstName;
  final String lastName;
  final String email;
  final bool isActive;
  final List<int> groupPermissionIds;
  final BuildContext context;

  const StaffMemberAdded(
    this.firstName,
    this.lastName,
    this.email,
    this.isActive,
    this.groupPermissionIds,
    this.context,
  );
}

class ProductAttributeUpdated extends StaffMemberEvent {
  final BuildContext context;
  final String attribute;
  final int id;

  const ProductAttributeUpdated(
    this.context,
    this.attribute,
    this.id,
  );
}
