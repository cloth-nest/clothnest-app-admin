import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
"id": 1,
                "status": "DELIVERED",
                "total": 20,
                "deliveryMethod": "NORMAL",
                "paymentMethod": "CASH",
                "paymentStatus": "PAID",
                "createdAt": "2023-12-27T11:40:27.405Z",
                "user": {
                    "firstName": "",
                    "lastName": "Root"
                }
 */

class OrderModel {
  final int id;
  final String status;
  final double total;
  final String createdAt;
  final String deliveryMethod;
  final String paymentMethod;
  final String paymentStatus;
  final String firstName;
  final String lastName;

  OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'total': total,
      'createdAt': createdAt,
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int,
      status: map['status'] as String,
      total: map['total'] * 1.0,
      createdAt: map['createdAt'] as String,
      deliveryMethod: map['deliveryMethod'] ?? '',
      paymentMethod: map['paymentMethod'] as String,
      paymentStatus: map['paymentStatus'] as String,
      firstName: map['user'] == null ? '' : map['user']['firstName'] ?? '',
      lastName: map['user'] == null ? '' : map['user']['lastName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
