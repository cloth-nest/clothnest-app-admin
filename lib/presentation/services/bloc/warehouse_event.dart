// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'warehouse_bloc.dart';

abstract class WarehouseEvent extends Equatable {
  const WarehouseEvent();

  @override
  List<Object> get props => [];
}

class WarehouseStarted extends WarehouseEvent {
  final BuildContext context;
  const WarehouseStarted({
    required this.context,
  });
}

class WarehouseAdded extends WarehouseEvent {
  final BuildContext context;
  final String warehouseName;
  const WarehouseAdded({
    required this.context,
    required this.warehouseName,
  });
}
