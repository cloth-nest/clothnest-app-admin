// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:grocery/data/models/address.dart';
import 'package:grocery/data/models/cart.dart';
import 'package:grocery/data/models/product.dart';

class Order {
  String? id;
  String? status;
  Address? address;
  double? total;
  int? shippingFee;
  final String phoneNum;
  final int addressId;
  final String deliveryDate;
  final String paymentMethod;
  final List<Cart> productList;
  final List<Product>? products;
  final List<Map<String, dynamic>>? orderDetailList;
  String? createdAt;
  String? email;
  int? totalQuantity;

  Order({
    this.id,
    this.status,
    this.total,
    this.createdAt,
    this.address,
    this.shippingFee,
    this.products,
    required this.phoneNum,
    required this.addressId,
    required this.deliveryDate,
    required this.paymentMethod,
    required this.productList,
    this.orderDetailList,
    this.email,
    this.totalQuantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNum': phoneNum,
      'addressId': addressId,
      'deliveryDate': deliveryDate,
      'paymentMethod': paymentMethod,
      'productList': productList
          .map((x) => {
                'id': x.product.id,
                'quantity': x.quantity,
              })
          .toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      total: double.parse(map['total'].toString()),
      status: map['status'] as String,
      phoneNum: map['phoneNum'] as String,
      addressId: 3,
      deliveryDate: map['deliveryDate'] as String,
      paymentMethod: map['paymentMethod'] as String,
      createdAt: map['orderDate'] as String,
      address: Address.fromMap(map['address']),
      shippingFee: map['shippingFee'] as int,
      email: map['user'] != null ? map['user']['mail'] : '',
      totalQuantity: map['totalQuantity'] ?? 0,
      productList: [],
      orderDetailList: List<Map<String, dynamic>>.from(
        (map['orderDetailList']).map(
          (x) {
            return {
              'product': Product.fromMap((x['product'])),
              'quantity': x['quantity'],
              'price': x['price'],
            };
          },
        ),
      ),
      products: List<Product>.from(
        (map['orderDetailList']).map(
          (x) {
            return Product.fromMap((x['product']));
          },
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
