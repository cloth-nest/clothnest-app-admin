import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/group_permission.dart';
import 'package:grocery/data/models/staff.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/bloc/detail_staff_bloc.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class DetailStaffMemberDialog extends StatefulWidget {
  final int idStaff;

  const DetailStaffMemberDialog({
    super.key,
    required this.idStaff,
  });

  @override
  State<DetailStaffMemberDialog> createState() =>
      _DetailStaffMemberDialogState();
}

class _DetailStaffMemberDialogState extends State<DetailStaffMemberDialog> {
  bool isActive = false;
  bool isActiveUser = false;
  List<GroupPermission> groupPermissions = [];
  List<GroupPermission> selectedGroupPermissions = [];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
  }

  DetailStaffBloc get _bloc => BlocProvider.of<DetailStaffBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(DetailStaffStarted(idStaff: widget.idStaff));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<DetailStaffBloc, DetailStaffState>(
      listener: (context, state) {
        if (state is DetailStaffInitial) {
          Staff staff = state.staff;

          selectedGroupPermissions = staff.groupPermissions;
          groupPermissions = state.groupPermissions;
          lastNameController.text = staff.lastName;
          firstNameController.text = staff.firstName;
          emailController.text = staff.email;
          isActiveUser = staff.isActive;
          for (var i = 0; i < groupPermissions.length; i++) {
            if (selectedGroupPermissions.contains(groupPermissions[i])) {
              groupPermissions[i] =
                  groupPermissions[i].copyWith(selected: true);
            }
          }

          setState(() {});
        }
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        clipBehavior: Clip.hardEdge,
        title: Container(
          width: 400,
          padding: const EdgeInsets.only(
            bottom: 10,
            top: 10,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height * .5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail Staff Member', style: AppStyles.semibold),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldInput(
                          controller: firstNameController,
                          hintText: 'First Name',
                          onChanged: (value) {
                            if (_isValidate()) {
                              setState(() {
                                isActive = true;
                              });
                            } else {
                              setState(() {
                                isActive = false;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFieldInput(
                        controller: lastNameController,
                        hintText: 'Last Name',
                        onChanged: (value) {
                          if (_isValidate()) {
                            setState(() {
                              isActive = true;
                            });
                          } else {
                            setState(() {
                              isActive = false;
                            });
                          }
                        },
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    controller: emailController,
                    hintText: 'Email',
                    onChanged: (value) {
                      if (_isValidate()) {
                        setState(() {
                          isActive = true;
                        });
                      } else {
                        setState(() {
                          isActive = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isActiveUser,
                        onChanged: (value) {
                          setState(() {
                            isActiveUser = !isActiveUser;
                            isActive = true;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      Text('User is active', style: AppStyles.medium),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Permissions: User is assigned to:',
                    style: AppStyles.medium,
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<DetailStaffBloc, DetailStaffState>(
                      builder: (context, state) {
                    if (state is DetailStaffLoading) {
                      return LoadingScreen().showLoadingWidget();
                    } else if (state is DetailStaffInitial) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: groupPermissions[index].selected,
                                    onChanged: (value) {
                                      if (value == true) {
                                        selectedGroupPermissions
                                            .add(groupPermissions[index]);
                                      } else {
                                        selectedGroupPermissions
                                            .removeAt(index);
                                      }

                                      setState(() {
                                        isActive = selectedGroupPermissions
                                                .isNotEmpty &&
                                            _isValidate();
                                        groupPermissions[index] =
                                            groupPermissions[index]
                                                .copyWith(selected: value);
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      groupPermissions[index].name,
                                      style: AppStyles.medium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: groupPermissions.length,
                        ),
                      );
                    }
                    return LoadingScreen().showLoadingWidget();
                  }),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildButton(
                          title: 'Back',
                          callback: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.white,
                          borderColor: AppColors.box.withOpacity(0.5),
                          textColor: AppColors.black,
                        ),
                        const SizedBox(width: 10),
                        _buildButton(
                          title: 'Update',
                          callback: () {
                            if (isActive) {
                              Navigator.of(context).pop([
                                firstNameController.text.trim(),
                                lastNameController.text.trim(),
                                emailController.text.trim(),
                                isActiveUser,
                                selectedGroupPermissions,
                              ]);
                            }
                          },
                          color: isActive
                              ? Colors.black
                              : AppColors.textGray999.withOpacity(0.3),
                          textColor: isActive ? Colors.white : Colors.black,
                          width: 200,
                        ),
                      ],
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

  bool _isValidate() {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Widget _buildButton(
      {required String title,
      required VoidCallback callback,
      required Color color,
      Color? borderColor,
      required Color textColor,
      double? width}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width ?? 100,
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
