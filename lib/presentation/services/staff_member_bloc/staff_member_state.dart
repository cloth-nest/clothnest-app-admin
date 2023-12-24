part of 'staff_member_bloc.dart';

abstract class StaffMemberState extends Equatable {
  const StaffMemberState();

  @override
  List<Object> get props => [];
}

class StaffMemberInitital extends StaffMemberState {}

class StaffMemberLoading extends StaffMemberState {}

class StaffMemberError extends StaffMemberState {
  final String errorMessage;

  const StaffMemberError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class StaffMemberLoaded extends StaffMemberState {
  final StaffDataSourceAsync staffDataSourceAsync;
  final bool? isAdded;
  const StaffMemberLoaded(this.staffDataSourceAsync, this.isAdded);

  @override
  List<Object> get props => [staffDataSourceAsync];
}
