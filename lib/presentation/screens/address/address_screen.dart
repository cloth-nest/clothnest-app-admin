import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grocery/data/models/address.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/address/add_edit_address_screen.dart';
import 'package:grocery/presentation/screens/address/components/item_address.dart';
import 'package:grocery/presentation/services/address_bloc/address_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class AddressScreen extends StatefulWidget {
  final bool? isFromOrder;

  const AddressScreen({
    super.key,
    this.isFromOrder = true,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  AddressBloc get _bloc => BlocProvider.of<AddressBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(AddressStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'My Address',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const AddEditAddressScreen(currentAddress: null),
                ),
              );
              if (result != null) {
                _bloc.add(AddressStarted());
              }
            },
            child: Text(
              'Add',
              style: AppStyles.medium.copyWith(
                color: AppColors.primary,
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressSuccess) {
            List<Address> addresses = state.addresses;

            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                Address address = addresses[index];

                return Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),

                  // The start action pane is the one at the left or the top side.
                  endActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {}),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        onPressed: (id) {
                          if (address.setAsPrimary == true) {
                            showSnackBar(
                              context,
                              'You can\'t delete this address',
                              const Icon(Icons.error),
                            );
                          } else {
                            _bloc.add(AddressDeleted(id: address.id!));
                          }
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(address);
                    },
                    child: ItemAddress(
                      address: address,
                      callback: (id) async {
                        if (widget.isFromOrder!) {
                          Navigator.of(context).pop(address);
                        } else {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditAddressScreen(currentAddress: address),
                            ),
                          );

                          if (result != null) {
                            _bloc.add(AddressStarted());
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
