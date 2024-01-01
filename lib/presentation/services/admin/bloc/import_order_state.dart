// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'import_order_bloc.dart';

abstract class ImportOrderState extends Equatable {
  const ImportOrderState();

  @override
  List<Object> get props => [];
}

class ImportOrderInitial extends ImportOrderState {
  final List<Warehouse> warehouses;

  const ImportOrderInitial({
    required this.warehouses,
  });
}

class ImportOrderLoading extends ImportOrderState {}

class ImportOrderScanned extends ImportOrderState {
  final CartEntity cart;

  const ImportOrderScanned({required this.cart});
}

class CheckOutSuccess extends ImportOrderState {}
