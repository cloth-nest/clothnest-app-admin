// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'warehouse_bloc.dart';

abstract class WarehouseState extends Equatable {
  const WarehouseState();

  @override
  List<Object> get props => [];
}

class WarehouseInitial extends WarehouseState {
  final List<Warehouse> warehouses;
  const WarehouseInitial({
    required this.warehouses,
  });
}

class WarehouseLoading extends WarehouseState {}

class AddWarehouseSuccess extends WarehouseState {}

class WarehouseFailure extends WarehouseState {
  final String errorMessage;

  const WarehouseFailure({required this.errorMessage});
}
