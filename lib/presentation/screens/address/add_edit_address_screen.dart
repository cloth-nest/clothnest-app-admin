import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/address.dart';
import 'package:grocery/data/models/place.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/add_edit_address_bloc/add_edit_address_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? currentAddress;

  const AddEditAddressScreen({
    super.key,
    this.currentAddress,
  });

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  AddEditAddressBloc get _bloc => BlocProvider.of<AddEditAddressBloc>(context);

  List<Place> provinces = [];
  List<Place> districts = [];
  List<Place> wards = [];

  late Place valueProvince = Place();
  late Place valueDistrict = Place();
  late Place valueWard = Place();

  bool hasWards = false;
  bool isPrimary = true;

  final TextEditingController controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String headerText = 'Edit Address';

  @override
  void initState() {
    super.initState();
    _bloc.add(AddEditAddressStarted(widget.currentAddress));

    if (widget.currentAddress == null) {
      headerText = 'Add Address';
      _bloc.add(const ProvincesFetched(null));
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  // Future<void> getCurrentLocation(Position position) async {
  //   late List<Placemark> placemarks;
  //   try {
  //     placemarks =
  //         await placemarkFromCoordinates(position.latitude, position.longitude);
  //   } catch (e) {
  //     print('error: ${e.toString()}');
  //   }
  //   print('placemarks:${placemarks}');
  //   if (placemarks.isNotEmpty) {
  //     Placemark placemark = placemarks[0];
  //     String? street = placemark.street;
  //     String? cityName = placemark.name;
  //     String result = '${street!} ${cityName!}';
  //     Navigator.pop(context, result);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: BlocBuilder<AddEditAddressBloc, AddEditAddressState>(
          builder: (context, state) {
            return Text(
              headerText,
              style: AppStyles.bold.copyWith(
                fontSize: 18,
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: saveAddress,
            child: Text(
              'Save',
              style: AppStyles.medium.copyWith(
                color: AppColors.primary,
              ),
            ),
          )
        ],
      ),
      body: BlocConsumer<AddEditAddressBloc, AddEditAddressState>(
        listener: (context, state) {
          if (state is AddEditAddressFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(Icons.error_outline),
            );
          } else if (state is AddEditAddressLoading) {
            LoadingScreen().show(context: context);
          } else if (state is AddEditAddressSuccess) {
            LoadingScreen().hide();
            Navigator.of(context).pop(state.newAddress);
          }
        },
        builder: (context, state) {
          if (state is EditAddressMode) {
            Address currentAddress = state.currentAddress;

            nameController.text = currentAddress.name;
            phoneController.text = currentAddress.phoneNum;
            controller.text = currentAddress.detail;
            isPrimary = currentAddress.setAsPrimary;

            _bloc.add(ProvincesFetched(currentAddress.provinceName));

            _bloc.add(DistrictsFetched(
              code: currentAddress.provinceId,
              name: currentAddress.districtName,
            ));

            _bloc.add(WardsFetched(
              code: currentAddress.districtId,
              name: currentAddress.wardName,
            ));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              children: [
                const SizedBox(height: 15),
                Text('Contact', style: AppStyles.medium),
                const SizedBox(height: 10),
                TextFieldInput(hintText: 'Name', controller: nameController),
                const SizedBox(height: 10),
                TextFieldInput(hintText: 'Phone', controller: phoneController),
                const SizedBox(height: 15),
                // GestureDetector(
                //   onTap: getCurrentPoint,
                //   child: Box(
                //     padding: const EdgeInsets.symmetric(vertical: 15),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Icon(
                //           FontAwesomeIcons.locationCrosshairs,
                //           color: AppColors.primary,
                //         ),
                //         const SizedBox(width: 20),
                //         Text(
                //           'Sử dụng vị trí hiện tại của tôi',
                //           style: AppStyles.regular,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 15),
                Text(
                  'City',
                  style: AppStyles.medium,
                ),
                const SizedBox(height: 10),
                _provinces(),
                const SizedBox(height: 10),
                Text(
                  'District',
                  style: AppStyles.medium,
                ),
                const SizedBox(height: 10),
                _districts(),
                const SizedBox(height: 15),
                Text(
                  'Ward',
                  style: AppStyles.medium,
                ),
                const SizedBox(height: 10),
                _wards(),
                const SizedBox(height: 15),
                Text(
                  'Street Name, Building',
                  style: AppStyles.medium,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                    hintText: 'Street Name, Building, House No.',
                    controller: controller),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Set a Primary', style: AppStyles.medium),
                    const Spacer(),
                    Checkbox(
                      value: isPrimary,
                      fillColor: MaterialStateProperty.all(AppColors.primary),
                      onChanged: (value) {
                        setState(() {
                          isPrimary = !isPrimary;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget comboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.gray,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          isExpanded: true,
          value: value,
          style: AppStyles.medium,
          dropdownColor: Colors.white,
          items: source
              .map(
                (e) => DropdownMenuItem<dynamic>(
                  value: e,
                  child: Text(
                    '${e.name}',
                    style: AppStyles.medium,
                  ),
                ),
              )
              .toList(),
          onChanged: callback,
        ),
      ),
    );
  }

  Widget _provinces() {
    return BlocBuilder<AddEditAddressBloc, AddEditAddressState>(
      builder: (context, state) {
        if (state is AddressFetchedSuccess) {
          provinces = state.provinces;
          valueProvince = state.currentProvince;

          return comboBox(provinces, (s) {
            _bloc.add(ProvincesChanged(place: s));
            _bloc.add(DistrictsFetched(code: s.code));
          }, valueProvince);
        }
        return const SizedBox();
      },
    );
  }

  Widget _districts() {
    return BlocBuilder<AddEditAddressBloc, AddEditAddressState>(
      builder: (context, state) {
        if (state is AddressFetchedSuccess) {
          districts = state.districts;

          valueDistrict = state.currentDistrict;

          return comboBox(districts, (s) {
            _bloc.add(DistrictsChanged(place: s));
            _bloc.add(WardsFetched(code: s.code));
          }, valueDistrict);
        }
        return const SizedBox();
      },
    );
  }

  Widget _wards() {
    return BlocBuilder<AddEditAddressBloc, AddEditAddressState>(
      builder: (context, state) {
        if (state is AddressFetchedSuccess) {
          wards = state.wards;
          valueWard = state.currentWard;

          return comboBox(wards, (s) {
            _bloc.add(WardsChanged(place: s));
          }, valueWard);
        }
        return const SizedBox();
      },
    );
  }

  void saveAddress() {
    Address address = Address(
      setAsPrimary: isPrimary,
      name: nameController.text.trim(),
      provinceId: valueProvince.code ?? 0,
      provinceName: valueProvince.name!,
      districtId: valueDistrict.code ?? 0,
      districtName: valueDistrict.name!,
      wardCode: valueWard.code!.toString(),
      wardName: valueWard.name!,
      detail: controller.text.trim(),
      phoneNum: phoneController.text.trim(),
    );

    if (widget.currentAddress == null) {
      _bloc.add(AddressSaved(address: address));
    } else {
      address = address.copyWith(id: widget.currentAddress!.id);
      _bloc.add(AddressEditted(address: address));
    }
  }
}
