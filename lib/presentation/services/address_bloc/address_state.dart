part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressFailure extends AddressState {
  final String errorMessage;

  const AddressFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AddressSuccess extends AddressState {
  final List<Address> addresses;

  const AddressSuccess({required this.addresses});

  @override
  List<Object> get props => [addresses];
}
