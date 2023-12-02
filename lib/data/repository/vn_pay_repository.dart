import 'dart:convert';
import 'dart:developer';
// Import for Android features.
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
// ignore: depend_on_referenced_packages, unused_import
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

enum VNPayHashType {
  SHA256,
  HMACSHA512,
}

class VnPayRepository {
  static final VnPayRepository _instance = VnPayRepository();
  static VnPayRepository get instance => _instance;
  Map<String, dynamic> _sortParams(Map<String, dynamic> params) {
    final sortedParams = <String, dynamic>{};
    final keys = params.keys.toList()..sort();
    for (String key in keys) {
      sortedParams[key] = params[key];
    }
    return sortedParams;
  }

  String generatePaymentUrl({
    String url = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    required String version,
    String command = 'pay',
    required String tmnCode,
    String locale = 'vn',
    String currencyCode = 'VND',
    required String txnRef,
    String orderInfo = 'Pay Order',
    required double amount,
    required String returnUrl,
    required String ipAdress,
    String? createAt,
    required String vnpayHashKey,
    VNPayHashType vnPayHashType = VNPayHashType.HMACSHA512,
  }) {
    final params = <String, dynamic>{
      'vnp_Version': version,
      'vnp_Command': command,
      'vnp_TmnCode': tmnCode,
      'vnp_Locale': locale,
      'vnp_CurrCode': currencyCode,
      'vnp_TxnRef': txnRef,
      'vnp_OrderInfo': orderInfo,
      'vnp_Amount': (amount * 100).toStringAsFixed(0),
      'vnp_ReturnUrl': returnUrl,
      'vnp_IpAddr': ipAdress,
      'vnp_CreateDate': createAt ??
          DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
    };
    var sortedParam = _sortParams(params);
    final hashDataBuffer = StringBuffer();
    sortedParam.forEach((key, value) {
      hashDataBuffer.write(key);
      hashDataBuffer.write('=');
      hashDataBuffer.write(value);
      hashDataBuffer.write('&');
    });
    String hashData =
        hashDataBuffer.toString().substring(0, hashDataBuffer.length - 1);
    String query = Uri(queryParameters: sortedParam).query;
    String vnpSecureHash = "";

    if (vnPayHashType == VNPayHashType.SHA256) {
      List<int> bytes = utf8.encode(vnpayHashKey + hashData.toString());
      vnpSecureHash = sha256.convert(bytes).toString();
    } else {
      vnpSecureHash = Hmac(sha512, utf8.encode(vnpayHashKey))
          .convert(utf8.encode(hashData))
          .toString();
    }
    String paymentUrl =
        "$url?$query&vnp_SecureHashType=${vnPayHashType == VNPayHashType.HMACSHA512 ? "HmacSHA512" : "SHA256"}&vnp_SecureHash=$vnpSecureHash";
    return paymentUrl;
  }

  Future<WebViewWidget> show({
    required String paymentUrl,
    Function(Map<String, dynamic>)? onPaymentSuccess,
    Function(Map<String, dynamic>)? onPaymentError,
    Function()? onWebPaymentComplete,
  }) async {
    late final WebViewController controller;
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(paymentUrl),
      );
    return WebViewWidget(
      controller: controller,
    );
    // return WebView(
    //   onWebViewCreated: (controller) {},
    //   javascriptMode: JavascriptMode.unrestricted,
    //   initialUrl: paymentUrl,
    // );
  }
}

String vnpay(double amount) {
  final paymentUrl = VnPayRepository.instance.generatePaymentUrl(
    url:
        'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
    version: '2.0.1', //version of VNPAY, default is 2.0.1
    tmnCode: 'UVY7QA94', //vnpay tmn code, get from vnpay
    txnRef: DateTime.now()
        .millisecondsSinceEpoch
        .toString(), //ref code, default is timestamp
    orderInfo: 'Pay 30.000 VND', //order info, default is Pay Order
    amount: amount, //amount
    returnUrl:
        "https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl",
    ipAdress: '192.168.51.87', //Your IP address
    vnpayHashKey:
        'QWHUNEBSCZUSILCAYLDGCWVYWMZIKKKQ', //vnpay hash key, get from vnpay
    vnPayHashType: VNPayHashType
        .HMACSHA512, //hash type. Default is HmacSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2
  );

  log("paymentUrl: $paymentUrl");

  return paymentUrl;
}
