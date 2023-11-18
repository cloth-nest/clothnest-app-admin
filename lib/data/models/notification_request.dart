// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:grocery/data/models/data.dart';

class NotificationRequest {
  final Data data;
  final String to;

  NotificationRequest({
    required this.data,
    required this.to,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.toMap(),
      'to': to,
    };
  }

  factory NotificationRequest.fromMap(Map<String, dynamic> map) {
    return NotificationRequest(
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
      to: map['to'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationRequest.fromJson(String source) =>
      NotificationRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
