import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/screens/authentication/login_screen.dart';
import 'package:grocery/presentation/screens/authentication/sign_up_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_bloc.dart';
import 'package:grocery/presentation/services/authentication_bloc/authentication_state.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: ListView(
        children: [
          // logo & app name
          logoApp(),
          // background image
          backgroundImage(size),
          // some method login
          methodLogin(context),
        ],
      ),
    ));
  }

  Widget logoApp() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingHorizontal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kTopPadding),
          Image.asset(
            AppAssets.icLogo,
            fit: BoxFit.fitWidth,
            width: 50,
          ),
          const SizedBox(width: 10),
          // name app
          Image.asset(
            AppAssets.name,
            color: AppColors.text,
            fit: BoxFit.fitWidth,
            width: 105,
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget backgroundImage(Size size) {
    return Image.asset(
      AppAssets.onboarding,
      alignment: Alignment.centerRight,
      height: size.height * .5,
    );
  }

  Widget methodLogin(BuildContext context) {
    return Column(
      children: [
// login using facebook
        CustomButton(
          content: 'Sign up with Apple',
          onTap: () {},
          color: AppColors.text,
          icon: Image.asset(
            AppAssets.icApple,
          ),
        ),
        const SizedBox(height: 10),
        // login using google
        CustomButton(
          content: 'Sign up with Google',
          onTap: () {},
          color: Colors.white,
          textColor: AppColors.text,
          icon: Image.asset(
            AppAssets.icGoogle,
          ),
        ),
        const SizedBox(height: 10),
        // sign up
        CustomButton(
          content: 'Sign Up',
          onTap: () => navigateToSignUpScreen(context),
        ),
        const SizedBox(height: 10),
        // login
        GestureDetector(
          onTap: () => navigateToLoginScreen(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an Account? ',
                style: AppStyles.regular.copyWith(
                  fontSize: 15,
                ),
              ),
              Text(
                'Login Here',
                style: AppStyles.regular.copyWith(
                  color: AppColors.primary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SignUpScreen(),
      ),
    );
  }

  navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }
}
