import 'package:flutter/material.dart';
import 'package:grocery/data/models/address.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemAddress extends StatelessWidget {
  final Address address;
  final Function(int) callback;


  const ItemAddress({
    super.key,
    required this.address,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(address.id!),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: address.setAsPrimary
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: AppColors.primary,
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                ],
              ),
            ),
            address.setAsPrimary ? boxPrimary() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget boxPrimary() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        'Primary',
        style: AppStyles.regular.copyWith(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
