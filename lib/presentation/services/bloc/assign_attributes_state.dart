// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'assign_attributes_bloc.dart';

abstract class AssignAttributesState extends Equatable {
  const AssignAttributesState();

  @override
  List<Object> get props => [];
}

class AssignAttributesInitial extends AssignAttributesState
    implements Equatable {
  final List<Attribute> attributes;
  const AssignAttributesInitial({
    required this.attributes,
  });

  @override
  List<Object> get props => [attributes];
}

class AssignAttributesLoading extends AssignAttributesState {}
