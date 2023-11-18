import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CouponItem {
  final int id;
  final int couponId;
  final String code;
  final bool isActive;
  CouponItem({
    required this.id,
    required this.couponId,
    required this.code,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'couponId': couponId,
      'code': code,
      'isActive': isActive,
    };
  }

  factory CouponItem.fromMap(Map<String, dynamic> map) {
    return CouponItem(
      id: map['id'] as int,
      couponId: map['couponId'] as int,
      code: map['code'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponItem.fromJson(String source) =>
      CouponItem.fromMap(json.decode(source) as Map<String, dynamic>);

  CouponItem copyWith({
    int? id,
    int? couponId,
    String? code,
    bool? isActive,
  }) {
    return CouponItem(
      id: id ?? this.id,
      couponId: couponId ?? this.couponId,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
    );
  }
}
