import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery/data/models/cart_entity.dart';
import 'package:grocery/data/models/detail_product.dart';
import 'package:grocery/data/models/warehouse.dart';
import 'package:grocery/data/repository/order_repository.dart';
import 'package:grocery/data/repository/product_repository.dart';
import 'package:grocery/data/repository/warehouse_repository.dart';

part 'import_order_event.dart';
part 'import_order_state.dart';

class ImportOrderBloc extends Bloc<ImportOrderEvent, ImportOrderState> {
  final WarehouseRepository warehouseRepository;
  final ProductRepository productRepository;
  final OrderRepository orderRepository;

  ImportOrderBloc(
    this.warehouseRepository,
    this.productRepository,
    this.orderRepository,
  ) : super(ImportOrderLoading()) {
    on<ImportOrderStarted>((event, emit) async {
      try {
        emit(ImportOrderLoading());

        List<Warehouse>? results = await warehouseRepository.getWarehouses();

        emit(ImportOrderInitial(warehouses: results ?? []));
      } catch (e) {
        debugPrint('###error import order started: $e');
      }
    });
    on<ScanProduct>((event, emit) async {
      try {
        emit(ImportOrderLoading());

        DetailProduct? product =
            await productRepository.getProductDetail(event.idProduct);

        CartEntity cartEntity = CartEntity(
          variantId: product!.variantId,
          name: product.name,
          price: product.price,
          productId: product.id,
          quantity: 1,
          image: product.productImages.first.imgUrl,
        );

        emit(ImportOrderScanned(cart: cartEntity));
      } catch (e) {
        debugPrint('###error scan product: $e');
      }
    });
    on<CheckOutProduct>((event, emit) async {
      try {
        emit(ImportOrderLoading());

        await orderRepository.importOrder(
            carts: event.carts, warehouseId: event.warehouseId);

        emit(CheckOutSuccess());
      } catch (e) {
        debugPrint('###error scan product: $e');
      }
    });
  }
}
