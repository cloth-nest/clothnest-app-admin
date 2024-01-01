import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/screens/side_menu/components/info_card.dart';
import 'package:grocery/presentation/screens/side_menu/components/side_menu_expansion_tile.dart';
import 'package:grocery/presentation/screens/side_menu/components/side_menu_tile.dart';

class SideMenu extends StatefulWidget {
  final Function(String) callback;
  const SideMenu({
    super.key,
    required this.callback,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0xFFFAFAF9),
        child: SafeArea(
          child: Column(
            children: [
              const InfoCard(),
              GestureDetector(
                onTap: () {
                  widget.callback('Home');
                },
                child: const SideMenuTile(
                  icon: AppAssets.iconHome,
                  title: 'Home',
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.callback('Products');
                },
                child: SideMenuExpansionTile(
                  icon: AppAssets.iconProduct,
                  title: 'Products',
                  subTitles: const ['Categories'],
                  callback: (value) {
                    widget.callback(value);
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.callback('Orders');
                },
                child: const SideMenuTile(
                  icon: AppAssets.iconOrder,
                  title: 'Orders',
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  widget.callback('Configuration');
                },
                child: const SideMenuTile(
                  icon: AppAssets.iconConfiguration,
                  title: 'Configuration',
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  widget.callback('Logout');
                },
                child: const SideMenuTile(
                  icon: AppAssets.iconConfiguration,
                  title: 'Logout',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
