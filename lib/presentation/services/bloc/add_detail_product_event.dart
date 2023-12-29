// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_detail_product_bloc.dart';

abstract class AddDetailProductEvent extends Equatable {
  const AddDetailProductEvent();

  @override
  List<Object> get props => [];
}

class AddDetailProductStarted extends AddDetailProductEvent {
  final int idProduct;

  const AddDetailProductStarted({
    required this.idProduct,
  });
}

class AddDetailProductAdded extends AddDetailProductEvent {
  final int idProduct;
  final String variantName;
  final String price;
  final String weight;
  final List<Map<String, dynamic>>? selectedAttributeValues;
  final List<Map<String, dynamic>>? selectedWarehouses;
  final List<File> files;
  final String sku;

  const AddDetailProductAdded({
    required this.idProduct,
    required this.variantName,
    required this.price,
    this.selectedAttributeValues,
    this.selectedWarehouses,
    required this.files,
    required this.weight,
    required this.sku,
  });
}
