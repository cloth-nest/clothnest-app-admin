import 'package:flutter/widgets.dart';

abstract class ICategory {
  int getSize();
  Widget render(BuildContext context);
}
