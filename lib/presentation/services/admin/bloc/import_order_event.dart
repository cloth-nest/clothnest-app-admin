// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'import_order_bloc.dart';

abstract class ImportOrderEvent extends Equatable {
  const ImportOrderEvent();

  @override
  List<Object> get props => [];
}

class ImportOrderStarted extends ImportOrderEvent {}

class ScanProduct extends ImportOrderEvent {
  final int idProduct;
  const ScanProduct({
    required this.idProduct,
  });
}

class CheckOutProduct extends ImportOrderEvent {
  final List<CartEntity> carts;
  final int warehouseId;
  const CheckOutProduct({
    required this.carts,
    required this.warehouseId,
  });
}
