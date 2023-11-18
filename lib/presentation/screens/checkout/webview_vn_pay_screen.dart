import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grocery/data/repository/vn_pay_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebViewVNPayScreen extends StatefulWidget {
  final idInvoice;
  final double totalValue;

  const WebViewVNPayScreen({
    super.key,
    this.idInvoice,
    required this.totalValue,
  });

  @override
  State<WebViewVNPayScreen> createState() => _WebViewVNPayScreenState();
}

class _WebViewVNPayScreenState extends State<WebViewVNPayScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    String url = vnpay(widget.totalValue);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            String url = request.url;
            if (url.contains('vnp_ResponseCode')) {
              //final params = Uri.parse(url).queryParameters;
              // //send response to server
              // http.Response response = await http.post(
              //   Uri.parse('$baseUrl/api/vnpay-return'),
              //   headers: {'Content-Type': 'application/json'},
              //   body: jsonEncode({
              //     "vnp_ResponseCode": params['vnp_ResponseCode'],
              //     "vnp_TxnRef": widget.idInvoice.toString()
              //   }),
              // );
              log('success');

              // Navigator.pushReplacement(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.fade,
              //         child: OrderDetailPage(
              //             await futureGetOrderDetail(widget.IdInvoice)),
              //         childCurrent: widget));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
