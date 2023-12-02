import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/user.dart';
import 'package:grocery/data/services/cloudinary_service.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String urlImage = '';
  File? fileImage;

  EditProfileBloc get _bloc => BlocProvider.of<EditProfileBloc>(context);
  final _editProfileFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _mailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _mailController.text = widget.user.mail!;
    _firstNameController.text = widget.user.firstName!;
    _lastNameController.text = widget.user.lastName!;
    _phoneController.text = widget.user.phoneNum!;
    urlImage = widget.user.avatar!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Image.asset(AppAssets.icBack),
        ),
        title: Text(
          'Edit Profile',
          style: AppStyles.medium,
        ),
        actions: [
          TextButton(
            onPressed: saveProfile,
            child: Text(
              'Save',
              style: AppStyles.medium.copyWith(
                color: const Color(0xFFFE9870),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileLoading) {
            LoadingScreen().show(context: context);
          } else if (state is EditProfileFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(
                Icons.error_outline,
              ),
            );
          } else if (state is EditProfileSuccess) {
            LoadingScreen().hide();
            Navigator.of(context).pop(true);
            showSnackBar(
              context,
              'Edit successfully',
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _editProfileFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Spacer(),
                      fileImage == null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(urlImage),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(fileImage!),
                            ),
                      const Spacer(),
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(AppAssets.icCamera),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFieldInput(
                      hintText: 'Email', controller: _mailController),
                  const SizedBox(height: 10),
                  TextFieldInput(
                      hintText: 'First name', controller: _firstNameController),
                  const SizedBox(height: 10),
                  TextFieldInput(
                      hintText: 'Last name', controller: _lastNameController),
                  const SizedBox(height: 10),
                  TextFieldInput(
                      hintText: 'Phone Number', controller: _phoneController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    List<File> files = [];

    if (result != null) {
      for (var path in result.paths) {
        File file = File(path!);
        files.add(file);
      }
      if (mounted) {
        setState(() {
          fileImage = files[0];
        });
      }

      String newUrlImage = await uploadImage(files[0]);
      _bloc.add(AvatarChanged(newAvatarUrl: newUrlImage));
    } else {
      // User canceled the picker
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String? urlImage =
        await CloudinaryService().uploadImage(imageFile.path, 'profiles');
    return urlImage ?? '';
  }

  void saveProfile() {
    if (_editProfileFormKey.currentState!.validate()) {
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String phoneNum = _phoneController.text.trim();

      _bloc.add(
        EditProfileSaved(
          firstName: firstName,
          lastName: lastName,
          phoneNum: phoneNum,
        ),
      );
    }
  }
}
