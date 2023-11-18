import 'dart:convert';

class Statistic {
  final int countedUser;
  final int countedProduct;
  final double revenue;
  final int total;
  final int finished;
  final int inprogress;
  final int cancelled;
  Statistic({
    required this.countedUser,
    required this.countedProduct,
    required this.revenue,
    required this.total,
    required this.finished,
    required this.inprogress,
    required this.cancelled,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countedUser': countedUser,
      'countedProduct': countedProduct,
      'revenue': revenue,
      'total': total,
      'finished': finished,
      'inprogress': inprogress,
      'cancelled': cancelled,
    };
  }

  factory Statistic.fromMap(Map<String, dynamic> map) {
    return Statistic(
      countedUser: map['users'] ?? 0,
      countedProduct: map['products'] ?? 0,
      revenue: map['revenue'] ?? 0,
      total: map['transactions']['total'] ?? 0,
      finished: map['transactions']['finished'] ?? 0,
      inprogress: map['transactions']['inprogress'] ?? 0,
      cancelled: map['transactions']['cancelled'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Statistic.fromJson(String source) =>
      Statistic.fromMap(json.decode(source) as Map<String, dynamic>);

  Statistic copyWith({
    int? countedUser,
    int? countedProduct,
    double? revenue,
    int? total,
    int? finished,
    int? inprogress,
    int? cancelled,
  }) {
    return Statistic(
      countedUser: countedUser ?? this.countedUser,
      countedProduct: countedProduct ?? this.countedProduct,
      revenue: revenue ?? this.revenue,
      total: total ?? this.total,
      finished: finished ?? this.finished,
      inprogress: inprogress ?? this.inprogress,
      cancelled: cancelled ?? this.cancelled,
    );
  }
}
