import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grocery/data/models/promo.dart';
import 'package:grocery/presentation/res/dimensions.dart';

class ItemPromo extends StatelessWidget {
  final Promo promo;

  const ItemPromo({
    super.key,
    required this.promo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kPaddingHorizontal),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(promo.image),
      ),
    );
  }
}
