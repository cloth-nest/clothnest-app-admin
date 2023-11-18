part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressStarted extends AddressEvent {}

class AddressDeleted extends AddressEvent {
  final int id;

  const AddressDeleted({required this.id});

  @override
  List<Object> get props => [id];
}
