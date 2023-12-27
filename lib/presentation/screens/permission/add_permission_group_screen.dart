import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/permission.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/bloc/add_permission_group_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class AddPermissionGroupScreen extends StatefulWidget {
  const AddPermissionGroupScreen({
    super.key,
  });

  @override
  State<AddPermissionGroupScreen> createState() =>
      _AddPermissionGroupScreenState();
}

class _AddPermissionGroupScreenState extends State<AddPermissionGroupScreen> {
  TextEditingController nameController = TextEditingController();
  AddPermissionGroupBloc get _bloc =>
      BlocProvider.of<AddPermissionGroupBloc>(context);

  List<Permission> permissions = [];
  List<Permission> selectedpermissions = [];

  bool isAdded = false;

  @override
  void initState() {
    super.initState();

    _bloc.add(AddPermissionInit());
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(isAdded),
          child: Image.asset(AppAssets.icBack),
        ),
        title: Text(
          'New Permission Group',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<AddPermissionGroupBloc, AddPermissionGroupState>(
        listener: (context, state) {
          if (state is AddPermissionLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is AddPermissionInitial) {
            permissions = state.permissions;
            return LoadingScreen().hide();
          } else {
            LoadingScreen().hide();
            isAdded = true;
            setState(() {
              selectedpermissions = [];
              nameController = TextEditingController();
            });
            showSnackBar(
              context,
              'Add permission group successfully',
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General Information',
                    style: AppStyles.semibold,
                  ),
                  const SizedBox(height: 5),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  Text(
                    'Group Name',
                    style: AppStyles.medium,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    hintText: 'Group Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Permission',
                    style: AppStyles.semibold,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Expand or restrict group\'s permissions to access certain part of saleor system.',
                    style: AppStyles.medium,
                  ),
                  const SizedBox(height: 5),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  BlocBuilder<AddPermissionGroupBloc, AddPermissionGroupState>(
                    builder: (context, state) => GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 10,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selectedpermissions
                                    .contains(permissions[index]),
                                onChanged: (value) {
                                  if (value == true) {
                                    selectedpermissions.add(permissions[index]);
                                  } else {
                                    selectedpermissions.removeAt(index);
                                  }

                                  setState(() {
                                    permissions[index] = permissions[index]
                                        .copyWith(selected: value);
                                  });
                                },
                              ),
                              const SizedBox(width: 5),
                              Text(
                                permissions[index].name,
                                style: AppStyles.medium,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: permissions.length,
                    ),
                  ),
                  Center(
                    child: CustomButton(
                      margin: 0,
                      content: 'Create Permission Group',
                      onTap: () => {
                        _bloc.add(AddPermission(
                            groupPermissionName: nameController.text.trim(),
                            permissions: permissions))
                      },
                      width: size.width * .4,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 3,
      color: Colors.black12,
    );
  }
}
