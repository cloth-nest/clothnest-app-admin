import 'package:flutter/material.dart';
import 'package:grocery/data/models/address.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/widgets/box.dart';

class BoxAddress extends StatelessWidget {
  final Address address;
  const BoxAddress({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Image.asset(AppAssets.fakeMap),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.name,
                  style: AppStyles.medium.copyWith(fontSize: 15),
                ),
                Text(
                  address.detail,
                  style: AppStyles.regular.copyWith(fontSize: 13),
                ),
                Text(
                  '${address.wardName}, ${address.districtName}, ${address.provinceName}',
                  style: AppStyles.regular.copyWith(fontSize: 13),
                ),
                Text(
                  address.phoneNum,
                  style: AppStyles.regular.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
