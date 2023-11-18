import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/bottom_navigation_bar.dart/bottom_navigation_bar_screen.dart'
    as admin;
import 'package:grocery/presentation/screens/bottom_navigation_bar.dart/bottom_navigation_bar_screen.dart'
    as user;
import 'package:grocery/presentation/services/login_bloc/login_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _loginInFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  navigateToBottomNavigationScreen(String role) {
    if (role == "Admin") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const admin.BottomNavigationBarScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const user.BottomNavigationBarScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          LoadingScreen().hide();
          showSnackBar(
            context,
            state.error,
            const Icon(
              Icons.error,
              color: AppColors.primary,
            ),
          );
        } else if (state is LoginLoading) {
          LoadingScreen().show(context: context);
        } else if (state is LoginSuccess) {
          LoadingScreen().hide();
          navigateToBottomNavigationScreen(state.role);
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: Form(
            key: _loginInFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
                vertical: kTopPadding,
              ),
              child: ListView(
                children: [
                  Text(
                    'Login to continue',
                    style: AppStyles.bold.copyWith(fontSize: 25),
                  ),
                  const SizedBox(height: 40),
                  // email field
                  TextFieldInput(
                    controller: emailController,
                    hintText: 'Email',
                    type: TextInputType.emailAddress,
                    prefixIcon: Image.asset(AppAssets.icEmail),
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
                  const SizedBox(height: 50),
                  // btn login
                  CustomButton(
                    content: 'Log In',
                    onTap: logIn,
                    margin: 0,
                  ),
                  const SizedBox(height: 10),
                  // forgot password
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.primary,
                      ),
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

  void logIn() {
    if (_loginInFormKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      context.read<LoginBloc>().add(
            LoginButtonPressed(email: email, password: password),
          );
    }
  }
}
