import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/screens/side_menu/components/info_card.dart';
import 'package:grocery/presentation/screens/side_menu/components/side_menu_expansion_tile.dart';
import 'package:grocery/presentation/screens/side_menu/components/side_menu_tile.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

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
        child: const SafeArea(
          child: Column(
            children: [
              InfoCard(),
              SideMenuExpansionTile(
                icon: AppAssets.iconProduct,
                title: 'Products',
                subTitles: ['Categories'],
              ),
              SideMenuTile(
                icon: AppAssets.iconOrder,
                title: 'Orders',
              ),
              SideMenuExpansionTile(
                icon: AppAssets.iconDiscount,
                title: 'Discounts',
                subTitles: ['Vouchers'],
              ),
              SideMenuTile(
                icon: AppAssets.iconConfiguration,
                title: 'Configuration',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
