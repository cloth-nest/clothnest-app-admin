// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:grocery/data/models/order_detail.dart';

class OrderDetailModel {
  final int id;
  final String status;
  final double total;
  final String createdAt;
  final String detail;
  final List<OrderDetail> orderDetails;
  final String provinceName;
  final String districtName;
  final String wardName;
  final String phone;
  final String firstName;
  final String lastName;
  final double shippingFee;
  final double vatFee;
  final String email;

  OrderDetailModel({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.detail,
    required this.orderDetails,
    required this.provinceName,
    required this.districtName,
    required this.wardName,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.shippingFee,
    required this.vatFee,
    required this.email,
  });

  OrderDetailModel copyWith({
    int? id,
    String? status,
    double? total,
    String? createdAt,
    String? detail,
    List<OrderDetail>? orderDetails,
    String? provinceName,
    String? districtName,
    String? wardName,
    String? phone,
    String? firstName,
    String? lastName,
    double? shippingFee,
    double? vatFee,
  }) {
    return OrderDetailModel(
      id: id ?? this.id,
      status: status ?? this.status,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      detail: detail ?? this.detail,
      orderDetails: orderDetails ?? this.orderDetails,
      provinceName: provinceName ?? this.provinceName,
      districtName: districtName ?? this.districtName,
      wardName: wardName ?? this.wardName,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      shippingFee: shippingFee ?? this.shippingFee,
      vatFee: vatFee ?? this.vatFee,
      email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'total': total,
      'createdAt': createdAt,
      'detail': detail,
      'orderDetails': orderDetails.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
        id: map['id'] as int,
        status: map['status'] as String,
        total: map['total'] * 1.0,
        createdAt: map['createdAt'] as String,
        detail: map['address'] != null ? map['address']['detail'] : '',
        phone: map['address'] != null ? map['address']['phone'] ?? '' : '',
        firstName:
            map['address'] != null ? map['address']['firstName'] ?? '' : '',
        lastName:
            map['address'] != null ? map['address']['lastName'] ?? '' : '',
        districtName:
            map['address'] != null ? map['address']['lastName'] ?? '' : '',
        wardName:
            map['address'] != null ? map['address']['wardName'] ?? '' : '',
        provinceName:
            map['address'] != null ? map['address']['provinceName'] ?? '' : '',
        email: map['address'] != null ? map['address']['email'] ?? '' : '',
        orderDetails: map['orderDetails'] == null
            ? []
            : List<OrderDetail>.from(
                (map['orderDetails']).map<OrderDetail>(
                  (x) => OrderDetail.fromMap(x as Map<String, dynamic>),
                ),
              ),
        shippingFee: map['shippingFee'] * 1.0,
        vatFee: (map['total'] * 1.0 - map['shippingFee'] * 1.0) / 1.08);
  }
}
