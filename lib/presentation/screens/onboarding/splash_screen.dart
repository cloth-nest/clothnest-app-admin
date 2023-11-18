import 'package:flutter/material.dart';
import 'package:grocery/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          backgroundImage(),
          opacityBackground(size),
          contentSplash(context),
        ],
      ),
    );
  }

  void navigateToOnboardingScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const OnBoardingScreen(),
      ),
    );
  }

  Widget backgroundImage() {
    return Image.asset(
      AppAssets.splash,
      fit: BoxFit.cover,
    );
  }

  Widget opacityBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: const Color(0xFF000000).withOpacity(
          0.5,
        ),
      ),
    );
  }

  Widget contentSplash(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          // icon logo app
          Image.asset(
            AppAssets.icLogo,
          ),
          const SizedBox(height: 10),
          // name app
          Image.asset(
            AppAssets.name,
          ),
          const SizedBox(height: 20),
          Text(
            'Your daily needs',
            style: AppStyles.medium.copyWith(
              color: Colors.white,
            ),
          ),
          const Spacer(flex: 2),
          CustomButton(
            margin: 0,
            content: 'Get Started',
            onTap: () => navigateToOnboardingScreen(context),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
