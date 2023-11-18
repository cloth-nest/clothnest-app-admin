part of 'add_edit_address_bloc.dart';

abstract class AddEditAddressState extends Equatable {
  const AddEditAddressState();

  @override
  List<Object> get props => [];
}

class AddEditAddressInitial extends AddEditAddressState {}

class AddAddressMode extends AddEditAddressState {}

class EditAddressMode extends AddEditAddressState {
  final Address currentAddress;

  const EditAddressMode({required this.currentAddress});

  @override
  List<Object> get props => [currentAddress];
}

class AddEditAddressLoading extends AddEditAddressState {}

class AddEditAddressSuccess extends AddEditAddressState {
  final Address newAddress;

  const AddEditAddressSuccess({required this.newAddress});

  @override
  List<Object> get props => [newAddress];
}

class AddEditAddressFailure extends AddEditAddressState {
  final String errorMessage;

  const AddEditAddressFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AddressFetchedSuccess extends AddEditAddressState {
  final List<Place> provinces;
  final List<Place> wards;
  final List<Place> districts;
  final Place currentProvince;
  final Place currentDistrict;
  final Place currentWard;

  const AddressFetchedSuccess({
    required this.provinces,
    required this.wards,
    required this.districts,
    required this.currentDistrict,
    required this.currentProvince,
    required this.currentWard,
  });

  @override
  List<Object> get props => [
        provinces,
        wards,
        districts,
        currentDistrict,
        currentProvince,
        currentWard
      ];
}
