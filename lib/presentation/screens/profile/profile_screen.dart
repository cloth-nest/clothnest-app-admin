import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/user.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/address/address_screen.dart';
import 'package:grocery/presentation/screens/authentication/login_screen.dart';
import 'package:grocery/presentation/screens/profile/components/item_profile.dart';
import 'package:grocery/presentation/screens/profile/edit_profile_screen.dart';
import 'package:grocery/presentation/services/profile_bloc/profile_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc get _bloc => BlocProvider.of<ProfileBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(ProfileFetched());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            LoadingScreen().hide();
            showSnackBar(
              context,
              state.errorMessage,
              const Icon(Icons.error_outline),
            );
          } else if (state is ProfileLoading) {
            LoadingScreen().show(context: context);
          } else if (state is ProfileLoggoutSuccess) {
            LoadingScreen().hide();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          } else {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is ProfileSuccess) {
            final User user = state.user;

            return ListView(
              children: [
                SizedBox(height: size.height * 0.07),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.avatar!,
                  ),
                  radius: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  '${user.firstName!} ${user.lastName!}',
                  style: AppStyles.bold.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.mail!,
                  style: AppStyles.medium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.08),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ItemProfile(
                    title: 'Profile Settings',
                    subtitle: 'Change your basic profile',
                    callback: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            user: user,
                          ),
                        ),
                      );
                      if (result != null) {
                        _bloc.add(ProfileFetched());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ItemProfile(
                    title: 'My Address',
                    subtitle: 'Your Address',
                    callback: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const AddressScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ItemProfile(
                    title: 'Terms, Privacy, & Policy',
                    subtitle: 'Things You may want know',
                    callback: () {},
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ItemProfile(
                    title: 'Help & Support',
                    subtitle: 'Get support from us',
                    callback: () {},
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    _bloc.add(ProfileLoggedOut());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Logout',
                      style: AppStyles.regular,
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
