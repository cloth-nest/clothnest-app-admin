import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/address.dart';
import 'package:grocery/data/models/place.dart';
import 'package:grocery/data/repository/address_repository.dart';

part 'add_edit_address_event.dart';
part 'add_edit_address_state.dart';

class AddEditAddressBloc
    extends Bloc<AddEditAddressEvent, AddEditAddressState> {
  final AddressRepository _addressRepository;

  List<Place> provinces = [];
  List<Place> wards = [];
  List<Place> districts = [];
  Place currentProvince = Place();
  Place currentDistrict = Place();
  Place currentWard = Place();

  AddEditAddressBloc(this._addressRepository) : super(AddEditAddressInitial()) {
    on<ProvincesFetched>(_onProvincesFetched);
    on<DistrictsFetched>(_onDistrictsFetched);
    on<WardsFetched>(_onWardsFetched);
    on<AddressSaved>(_onSaved);
    on<AddEditAddressStarted>(_onStarted);
    on<ProvincesChanged>(_onProvincesChanged);
    on<DistrictsChanged>(_onDistrictsChanged);
    on<WardsChanged>(_onWardsChanged);
    on<AddressEditted>(_onEditted);
  }

  FutureOr<void> _onProvincesFetched(
      ProvincesFetched event, Emitter<AddEditAddressState> emit) async {
    provinces = await _addressRepository.getProvinces();

    if (event.name != null) {
      for (var province in provinces) {
        if (province.name == event.name) {
          currentProvince = province;
          break;
        }
      }
    }

    if (currentProvince.name == null) {
      currentProvince = provinces[0];
    }

    emit(AddressFetchedSuccess(
      provinces: provinces,
      wards: wards,
      districts: districts,
      currentProvince: currentProvince,
      currentWard: currentWard,
      currentDistrict: currentDistrict,
    ));
  }

  FutureOr<void> _onDistrictsFetched(
      DistrictsFetched event, Emitter<AddEditAddressState> emit) async {
    districts = await _addressRepository.getDistricts(event.code);

    if (event.name != null) {
      for (var district in districts) {
        if (district.name == event.name) {
          currentDistrict = district;
          break;
        }
      }
    }

    if (currentDistrict.name == null) {
      currentDistrict = districts[0];
    }

    emit(AddressFetchedSuccess(
      provinces: provinces,
      wards: wards,
      districts: districts,
      currentProvince: currentProvince,
      currentWard: currentWard,
      currentDistrict: currentDistrict,
    ));
  }

  FutureOr<void> _onWardsFetched(
      WardsFetched event, Emitter<AddEditAddressState> emit) async {
    wards = await _addressRepository.getWards(event.code);

    if (event.name != null) {
      for (var ward in wards) {
        if (ward.name == event.name) {
          currentWard = ward;
          break;
        }
      }
    }

    if (currentWard.name == null) {
      currentWard = wards[0];
    }

    emit(AddressFetchedSuccess(
      provinces: provinces,
      wards: wards,
      districts: districts,
      currentProvince: currentProvince,
      currentWard: currentWard,
      currentDistrict: currentDistrict,
    ));
  }

  FutureOr<void> _onSaved(
      AddressSaved event, Emitter<AddEditAddressState> emit) async {
    emit(AddEditAddressLoading());

    try {
      Address? address =
          await _addressRepository.createNewAddress(event.address);
      emit(AddEditAddressSuccess(newAddress: address!));
    } catch (e) {
      emit(AddEditAddressFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onStarted(
      AddEditAddressStarted event, Emitter<AddEditAddressState> emit) {
    if (event.currentAddress == null) {
      currentDistrict = Place();
      currentProvince = Place();
      currentWard = Place();
      wards = [];
      provinces = [];
      districts = [];

      emit(AddAddressMode());
    } else {
      currentDistrict = Place();
      currentProvince = Place();
      currentWard = Place();
      wards = [];
      provinces = [];
      districts = [];

      emit(EditAddressMode(currentAddress: event.currentAddress!));
    }
  }

  FutureOr<void> _onProvincesChanged(
      ProvincesChanged event, Emitter<AddEditAddressState> emit) {
    currentProvince = event.place;
    wards = [];
    currentWard = Place();
    districts = [];
    currentDistrict = Place();

    emit(AddressFetchedSuccess(
      provinces: provinces,
      wards: [],
      districts: [],
      currentProvince: currentProvince,
      currentWard: Place(),
      currentDistrict: Place(),
    ));
  }

  FutureOr<void> _onDistrictsChanged(
      DistrictsChanged event, Emitter<AddEditAddressState> emit) {
    currentDistrict = event.place;
    wards = [];
    currentWard = Place();

    emit(AddressFetchedSuccess(
      provinces: provinces,
      wards: wards,
      districts: districts,
      currentProvince: currentProvince,
      currentWard: currentWard,
      currentDistrict: currentDistrict,
    ));
  }

  FutureOr<void> _onWardsChanged(
      WardsChanged event, Emitter<AddEditAddressState> emit) {
    currentWard = event.place;

    emit(AddressFetchedSuccess(
      provinces: provinces,
      wards: wards,
      districts: districts,
      currentProvince: currentProvince,
      currentWard: currentWard,
      currentDistrict: currentDistrict,
    ));
  }

  FutureOr<void> _onEditted(
      AddressEditted event, Emitter<AddEditAddressState> emit) async {
    emit(AddEditAddressLoading());

    try {
      Address? address = await _addressRepository.updateAddress(event.address);
      emit(AddEditAddressSuccess(newAddress: address!));
    } catch (e) {
      emit(AddEditAddressFailure(errorMessage: e.toString()));
    }
  }
}
