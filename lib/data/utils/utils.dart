import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/data/repository/zalo_pay_repository.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:crypto/crypto.dart';

/// Function Format DateTime to String with layout string
String formatNumber(double value) {
  final f = NumberFormat("#,###", "vi_VN");
  return f.format(value);
}

/// Function Format DateTime to String with layout string
String formatDateTime(DateTime dateTime, String layout) {
  return DateFormat(layout).format(dateTime).toString();
}

int transIdDefault = 1;
String getAppTransId() {
  if (transIdDefault >= 100000) {
    transIdDefault = 1;
  }

  transIdDefault += 1;
  var timeString = formatDateTime(DateTime.now(), "yyMMdd_hhmmss");
  return sprintf("%s%06d", [timeString, transIdDefault]);
}

String getBankCode() => "zalopayapp";
String getDescription(String apptransid) =>
    "Merchant Demo thanh toán cho đơn hàng  #$apptransid";

String getMacCreateOrder(String data) {
  var hmac = Hmac(sha256, utf8.encode(ZaloPayConfig.key1));
  return hmac.convert(utf8.encode(data)).toString();
}

ThemeData blackSlider(BuildContext context) {
  return Theme.of(context).copyWith(
      sliderTheme: SliderThemeData(
          // rangeThumbShape:
          //     const RectRangeSliderThumbShape(enabledThumbRadius: 8),
          // thumbShape: const RectSliderThumbShape(enabledThumbRadius: 8),
          thumbColor: Colors.grey[800],
          activeTrackColor: Colors.grey[700],
          inactiveTrackColor: Colors.grey[400],
          activeTickMarkColor: Colors.white,
          inactiveTickMarkColor: Colors.white));
}

String getCurrentRouteOption(BuildContext context) {
  var isEmpty = ModalRoute.of(context) != null &&
          ModalRoute.of(context)!.settings.arguments != null &&
          ModalRoute.of(context)!.settings.arguments is String
      ? ModalRoute.of(context)!.settings.arguments as String
      : '';

  return isEmpty;
}

// class RectRangeSliderThumbShape extends RangeSliderThumbShape {
//   const RectRangeSliderThumbShape({
//     this.enabledThumbRadius = 10.0,
//     this.disabledThumbRadius,
//     this.elevation = 1.0,
//     this.pressedElevation = 6.0,
//   });

//   final double enabledThumbRadius;

//   final double? disabledThumbRadius;
//   double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

//   final double elevation;

//   final double pressedElevation;

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(
//         isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required bool isEnabled,
//     required bool isOnTop,
//     required TextDirection textDirection,
//     required SliderThemeData sliderTheme,
//     required Thumb thumb,
//     bool? isPressed,
//   }) async {
//     assert(sliderTheme.showValueIndicator != null);
//     assert(sliderTheme.overlappingShapeStrokeColor != null);

//     final Canvas canvas = context.canvas;
//     final Tween<double> radiusTween = Tween<double>(
//       begin: _disabledThumbRadius,
//       end: enabledThumbRadius,
//     );
//     final ColorTween colorTween = ColorTween(
//       begin: sliderTheme.disabledThumbColor,
//       end: sliderTheme.thumbColor,
//     );
//     final double radius = radiusTween.evaluate(enableAnimation);
//     final Tween<double> elevationTween = Tween<double>(
//       begin: elevation,
//       end: pressedElevation,
//     );

//     if (isOnTop ?? false) {
//       final Paint strokePaint = Paint()
//         ..color = sliderTheme.overlappingShapeStrokeColor!
//         ..strokeWidth = 1.0
//         ..style = PaintingStyle.stroke;
//       canvas.drawRect(
//           Rect.fromCenter(
//               center: center, width: 2 * radius, height: 2 * radius),
//           strokePaint);
//     }

//     final Color color = colorTween.evaluate(enableAnimation)!;

//     final double evaluatedElevation =
//         isPressed! ? elevationTween.evaluate(activationAnimation) : elevation;
//     final Path shadowPath = Path()
//       ..addArc(
//           Rect.fromCenter(
//               center: center, width: 2 * radius, height: 2 * radius),
//           0,
//           pi * 2);
//     canvas.drawShadow(shadowPath, Colors.black, evaluatedElevation, true);

//     canvas.drawRect(
//       Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
//       Paint()..color = color,
//     );
//   }
// }

// class RectSliderThumbShape extends SliderComponentShape {
//   const RectSliderThumbShape({
//     this.enabledThumbRadius = 10.0,
//     this.disabledThumbRadius,
//     this.elevation = 1.0,
//     this.pressedElevation = 6.0,
//   });

//   final double enabledThumbRadius;

//   final double? disabledThumbRadius;
//   double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

//   final double elevation;

//   final double pressedElevation;

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(
//         isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     assert(sliderTheme.disabledThumbColor != null);
//     assert(sliderTheme.thumbColor != null);

//     final Canvas canvas = context.canvas;
//     final Tween<double> radiusTween = Tween<double>(
//       begin: _disabledThumbRadius,
//       end: enabledThumbRadius,
//     );
//     final ColorTween colorTween = ColorTween(
//       begin: sliderTheme.disabledThumbColor,
//       end: sliderTheme.thumbColor,
//     );

//     final Color color = colorTween.evaluate(enableAnimation)!;
//     final double radius = radiusTween.evaluate(enableAnimation);

//     final Tween<double> elevationTween = Tween<double>(
//       begin: elevation,
//       end: pressedElevation,
//     );

//     final double evaluatedElevation =
//         elevationTween.evaluate(activationAnimation);
//     final Path path = Path()
//       ..addArc(
//           Rect.fromCenter(
//               center: center, width: 2 * radius, height: 2 * radius),
//           0,
//           pi * 2);
//     canvas.drawShadow(path, Colors.black, evaluatedElevation, true);

//     canvas.drawRect(
//       Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
//       Paint()..color = color,
//     );
//   }
// }
