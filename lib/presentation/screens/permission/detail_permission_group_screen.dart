import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/permission.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/bloc/bloc/detail_group_permission_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class DetailPermissionGroupScreen extends StatefulWidget {
  final int idGroupPermission;

  const DetailPermissionGroupScreen({
    super.key,
    required this.idGroupPermission,
  });

  @override
  State<DetailPermissionGroupScreen> createState() =>
      _DetailPermissionGroupScreenState();
}

class _DetailPermissionGroupScreenState
    extends State<DetailPermissionGroupScreen> {
  TextEditingController nameController = TextEditingController();
  DetailGroupPermissionBloc get _bloc =>
      BlocProvider.of<DetailGroupPermissionBloc>(context);

  List<Permission> permissions = [];
  List<Permission> selectedpermissions = [];

  bool isAdded = false;
  bool isActive = false;

  @override
  void initState() {
    super.initState();

    _bloc.add(DetailGroupPermissionStarted(
      idGroupPermission: widget.idGroupPermission,
    ));
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
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset(AppAssets.icBack),
        ),
        title: Text(
          'Detail Permission Group',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<DetailGroupPermissionBloc, DetailGroupPermissionState>(
        listener: (context, state) {
          if (state is DetailGroupPermissionLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is DetailGroupPermissionInitial) {
            permissions = state.permissions;
            nameController.text = state.groupName;
            selectedpermissions = state.selectedpermissions;
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
                    onChanged: (value) {
                      isActive = true;
                    },
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
                  BlocBuilder<DetailGroupPermissionBloc,
                      DetailGroupPermissionState>(
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

                                    isActive = true;
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
                    child: _buildButton(
                      title: 'Update Permission Group',
                      callback: () {
                        Navigator.of(context).pop([
                          nameController.text.trim(),
                          selectedpermissions.map((e) => e.id).toList()
                        ]);
                      },
                      color: isActive
                          ? Colors.black
                          : AppColors.textGray999.withOpacity(0.3),
                      textColor: isActive ? Colors.white : Colors.black,
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

  Widget _buildButton({
    required String title,
    required VoidCallback callback,
    required Color color,
    Color? borderColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null
              ? Border.all(
                  width: 1,
                  color: borderColor,
                )
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.semibold.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
