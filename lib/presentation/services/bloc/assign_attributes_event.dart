part of 'assign_attributes_bloc.dart';

abstract class AssignAttributesEvent extends Equatable {
  const AssignAttributesEvent();

  @override
  List<Object> get props => [];
}

class AssignAttributeInit extends AssignAttributesEvent {}
