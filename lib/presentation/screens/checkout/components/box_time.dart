import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/widgets/box.dart';
import 'package:intl/intl.dart';

class BoxTime extends StatefulWidget {
  const BoxTime({
    super.key,
  });

  @override
  State<BoxTime> createState() => _BoxTimeState();
}

class _BoxTimeState extends State<BoxTime> {
  DateTime deliveryDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2025),
        ).then((value) {
          setState(() {
            if (value != null) {
              deliveryDate = value;
            }
          });
        });
      },
      child: Box(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Image.asset(AppAssets.icClock),
            const SizedBox(width: 10),
            Text(
              DateFormat('dd-MM-yyyy – HH:MM').format(deliveryDate),
              style: AppStyles.medium,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
