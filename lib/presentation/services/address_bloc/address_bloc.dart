import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery/data/models/address.dart';
import 'package:grocery/data/repository/address_repository.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _addressRepository;
  List<Address> addresses = [];

  AddressBloc(this._addressRepository) : super(AddressInitial()) {
    on<AddressDeleted>(_onDeleted);
    on<AddressStarted>(_onStarted);
  }

  FutureOr<void> _onDeleted(
      AddressDeleted event, Emitter<AddressState> emit) async {
    emit(AddressLoading());

    try {
      await _addressRepository.deleteAddress(event.id);
      addresses.removeWhere((address) => address.id == event.id);

      emit(AddressSuccess(addresses: [...addresses]));
    } catch (e) {
      emit(AddressFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onStarted(
      AddressStarted event, Emitter<AddressState> emit) async {
    emit(AddressLoading());

    try {
      addresses = await _addressRepository.getAddresses();
      emit(AddressSuccess(addresses: addresses));
    } catch (e) {
      emit(AddressFailure(errorMessage: e.toString()));
    }
  }
}
