import 'package:intl/intl.dart';

extension MoneyExtension on double {
  String get toMoney {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '\$',
      decimalDigits: 2,
    ).format(this);
  }
}
