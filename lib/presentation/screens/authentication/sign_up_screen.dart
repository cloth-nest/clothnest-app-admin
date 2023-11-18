import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/user.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/authentication/login_screen.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_bloc.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_event.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_state.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    lastNameController.dispose();

    firstNameController.dispose();
  }

  navigateToLoginScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is RegistrationLoading) {
              LoadingScreen().show(context: context);
            } else if (state is RegistrationSuccess) {
              LoadingScreen().hide();
              navigateToLoginScreen();
            } else if (state is RegistrationFailure) {
              LoadingScreen().hide();
              showSnackBar(
                context,
                state.error,
                const Icon(
                  Icons.error,
                  color: AppColors.primary,
                ),
              );
              log('error registration: ${state.error}');
            }
          },
          child: Form(
            key: _signUpFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
                vertical: kTopPadding,
              ),
              child: ListView(
                children: [
                  Text(
                    "Register",
                    style: AppStyles.bold.copyWith(fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // btn login facebook
                      Expanded(
                        child: CustomButton(
                          content: '',
                          margin: 0,
                          onTap: () {},
                          color: AppColors.text,
                          icon: Image.asset(
                            AppAssets.icApple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // btn login gg
                      Expanded(
                        child: CustomButton(
                          margin: 0,
                          content: '',
                          onTap: () {},
                          color: Colors.transparent,
                          icon: Image.asset(AppAssets.icGoogle),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // email field
                  TextFieldInput(
                    controller: emailController,
                    hintText: 'Email',
                    type: TextInputType.emailAddress,
                    prefixIcon: Image.asset(AppAssets.icEmail),
                  ),
                  const SizedBox(height: 15),
                  // phone field
                  TextFieldInput(
                    controller: phoneController,
                    hintText: 'Phone',
                    type: TextInputType.number,
                    prefixIcon: Image.asset(AppAssets.icPhone),
                  ),
                  const SizedBox(height: 15),
                  // first name
                  TextFieldInput(
                    controller: firstNameController,
                    hintText: 'First name',
                    type: TextInputType.text,
                    prefixIcon: Image.asset(AppAssets.icUser),
                  ),
                  const SizedBox(height: 15),
                  // last name
                  TextFieldInput(
                    controller: lastNameController,
                    hintText: 'Last name',
                    type: TextInputType.text,
                    prefixIcon: Image.asset(AppAssets.icUser),
                  ),
                  const SizedBox(height: 15),
                  // password field
                  TextFieldInput(
                    controller: passwordController,
                    hintText: 'Password',
                    type: TextInputType.text,
                    isPass: true,
                    prefixIcon: Image.asset(AppAssets.icLock),
                  ),
                  const SizedBox(height: 15),
                  // confirm password field
                  TextFieldInput(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    type: TextInputType.text,
                    isPass: true,
                    prefixIcon: Image.asset(AppAssets.icLock),
                  ),
                  const SizedBox(height: 30),
                  // btn sign up
                  CustomButton(
                    content: 'Create Account',
                    onTap: createAccount,
                    margin: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() {
    if (_signUpFormKey.currentState!.validate()) {
      User user = User(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mail: emailController.text,
        password: passwordController.text,
        phoneNum: phoneController.text,
      );
      context.read<AuthenticationBloc>().add(
            RegistrationButtonPressed(user: user),
          );
    }
  }
}
