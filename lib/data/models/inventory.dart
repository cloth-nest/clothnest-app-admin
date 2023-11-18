import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductInventory {
  final String id;
  final int quantity;

  ProductInventory({
    required this.id,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
    };
  }

  factory ProductInventory.fromMap(Map<String, dynamic> map) {
    return ProductInventory(
      id: map['id'] as String,
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductInventory.fromJson(String source) =>
      ProductInventory.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Inventory {
  final List<ProductInventory> productList;

  Inventory({
    required this.productList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productList': productList.map((x) => x.toMap()).toList(),
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      productList: List<ProductInventory>.from(
        (map['productList'] as List<int>).map<ProductInventory>(
          (x) => ProductInventory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Inventory.fromJson(String source) =>
      Inventory.fromMap(json.decode(source) as Map<String, dynamic>);
}
