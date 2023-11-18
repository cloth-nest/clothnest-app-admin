// ignore_for_file: public_member_api_docs, sort_constructors_first
enum OrderStatus { finished, cancelled, inprogress }

class Transaction {
  final OrderStatus orderStatus;
  final String id;
  final String totalPayment;
  final String username;
  final String createdAt;

  Transaction({
    required this.orderStatus,
    required this.id,
    required this.totalPayment,
    required this.username,
    required this.createdAt,
  });
}
