import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/style.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        'Admin',
        style: AppStyles.regular,
      ),
    );
  }
}
