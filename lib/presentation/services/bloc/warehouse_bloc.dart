import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery/data/models/warehouse.dart';
import 'package:grocery/data/repository/warehouse_repository.dart';
import 'package:grocery/presentation/utils/functions.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  WarehouseRepository warehouseRepository;

  WarehouseBloc(this.warehouseRepository) : super(WarehouseLoading()) {
    on<WarehouseStarted>((event, emit) async {
      try {
        emit(WarehouseLoading());

        List<Warehouse>? warehouses = await warehouseRepository.getWarehouses();

        emit(WarehouseInitial(warehouses: warehouses ?? []));
      } catch (e) {
        debugPrint('on error: $e');
        emit(WarehouseFailure(errorMessage: e.toString()));
      }
    });
    on<WarehouseAdded>((event, emit) async {
      try {
        emit(WarehouseLoading());

        await warehouseRepository.createWarehouses(
            warehouseName: event.warehouseName);
        List<Warehouse>? warehouses = await warehouseRepository.getWarehouses();
        emit(WarehouseInitial(warehouses: warehouses ?? []));
      } catch (e) {
        debugPrint('on added: $e');
      }
    });
    on<WarehouseUpdated>((event, emit) async {
      try {
        emit(WarehouseLoading());

        await warehouseRepository.updateWarehouses(
          warehouseName: event.warehouseName,
          idWarehouse: event.idWarehouse,
        );
        List<Warehouse>? warehouses = await warehouseRepository.getWarehouses();
        emit(WarehouseInitial(warehouses: warehouses ?? []));
      } catch (e) {
        debugPrint('on added: $e');
      }
    });
    on<WarehouseDeleted>((event, emit) async {
      try {
        emit(WarehouseLoading());

        await warehouseRepository.deleteWarehouses(
          idWarehouse: event.idWarehouse,
        );
        List<Warehouse>? warehouses = await warehouseRepository.getWarehouses();
        emit(WarehouseInitial(warehouses: warehouses ?? []));
      } catch (e) {
        showSnackBar(
          event.context,
          'Warehouse is using',
          const Icon(Icons.error_outline),
        );
        debugPrint('on deleted: $e');
        emit(WarehouseFailure(errorMessage: e.toString()));
      }
    });
  }
}
