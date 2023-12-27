// ignore_for_file: public_member_api_docs, sort_constructors_first

class OrderDetail {
  final int id;
  final int quantity;
  final double price;
  final String image;
  final String name;

  OrderDetail({
    required this.id,
    required this.quantity,
    required this.price,
    required this.image,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'] as int,
      quantity: map['quantity'] as int,
      price: map['price'] * 1.0,
      image:
          map['productVariant'] != null ? map['productVariant']['image'] : '',
      name: map['productVariant'] != null ? map['productVariant']['name'] : '',
    );
  }
}
