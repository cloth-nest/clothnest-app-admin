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
  final BuildContext context;
  final String attribute;
  final int id;

  const StaffMemberAdded(
    this.context,
    this.attribute,
    this.id,
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
