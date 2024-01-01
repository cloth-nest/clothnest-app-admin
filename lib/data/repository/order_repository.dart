import 'dart:convert';
import 'dart:developer';

import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/cart_entity.dart';
import 'package:grocery/data/models/inventory.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/data/models/order_detail_model.dart';
import 'package:grocery/data/models/order_model.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class OrderRepository extends IServiceAPI {
  String urlCreateOrder = 'order/';
  String urlCreateOrderFromCart = 'order/cart';
  String urlGetAllOrderBelongToUser = 'order';
  String urlGetAllOrder = 'order/admin?page=1&limit=0';
  String urlGetDetailOrder = 'order/admin';
  String urlLogin = 'auth/login';
  String urlRefreshToken = 'auth/refresh-token';
  String urlLogout = "auth/logout";
  String urlUpdateStatus = "order/admin";
  String urlInventoryCheck = 'order/pre-order';
  String urlCheckCoupon = 'order/pre-order-cp';
  String urlImportOrder = 'order/admin/import';

  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;

  OrderRepository(this._appData) {
    urlCreateOrder = localURL + urlCreateOrder;
    urlCreateOrderFromCart = localURL + urlCreateOrderFromCart;
    urlGetAllOrderBelongToUser = localURL + urlGetAllOrderBelongToUser;
    urlRefreshToken = localURL + urlRefreshToken;
    urlLogout = localURL + urlLogout;
    urlGetAllOrder = localURL + urlGetAllOrder;
    urlUpdateStatus = localURL + urlUpdateStatus;
    urlInventoryCheck = localURL + urlInventoryCheck;
    urlCheckCoupon = localURL + urlCheckCoupon;
    urlGetDetailOrder = localURL + urlGetDetailOrder;
    urlImportOrder = localURL + urlImportOrder;
  }

  @override
  Order convertToObject(value) {
    return Order.fromMap(value);
  }

  Future<Map<String, dynamic>?> checkCoupon(
      String coupon, List<Map<String, dynamic>> productList) async {
    try {
      final response = await apiServices.post(
        urlCheckCoupon,
        {
          'code': coupon,
          'productList': productList,
        },
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'Coupon invalid') {
        return null;
      }

      Map<String, dynamic> result = {};
      result['type'] = baseResponse.data['type'];
      result['value'] = baseResponse.data['value'];
      return result;
    } catch (e) {
      log('error check coupon: $e');
      return null;
    }
  }

  Future<bool> checkInventory(Inventory inventory) async {
    try {
      final response = await apiServices.post(
        urlInventoryCheck,
        inventory.toMap(),
        _appData.headers,
      );

      BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'Product not available') {
        return false;
      }
    } catch (e) {
      log('error check inventory: $e');
      return false;
    }
    return true;
  }

  Future<void> importOrder({
    required List<CartEntity> carts,
    required int warehouseId,
  }) async {
    try {
      final response = await apiServices.post(
        urlImportOrder,
        {
          'warehouseId': warehouseId,
          'carts': carts
              .map(
                (e) => {
                  'variantId': e.variantId,
                  'quantity': e.quantity,
                },
              )
              .toList(),
        },
        _appData.headers,
      );
      print(response);
    } catch (e) {
      log('Error importOrder: $e');
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      final response = await apiServices.post(
        urlCreateOrder,
        order.toMap(),
        _appData.headers,
      );
      print(response);
    } catch (e) {
      log('Error create order: $e');
    }
  }

//"message" -> "invalid input syntax for type uuid: "7a78e280-f93b-48e4-b2df-480f6c826445}""
  Future<void> updateStatus(int orderId, bool isCancelled) async {
    try {
      final response = await apiServices.post(
        '$urlUpdateStatus/$orderId',
        {
          "orderStatus": isCancelled ? 'CANCELED' : 'DELIVERED',
        },
        _appData.headers,
      );
      print(response);
    } catch (e) {
      log('Error update status: $e');
    }
  }

  Future<void> createOrderFromCart(Order order) async {
    try {
      final response = await apiServices.post(
        urlCreateOrderFromCart,
        order.toMap(),
        _appData.headers,
      );
      print(response);
    } catch (e) {
      log('Error create order from cart: $e');
    }
  }

  Future<List<Order>> getAllOrderBelongToUser() async {
    List<Order> orders = [];
    try {
      final response = await apiServices.get(
        urlGetAllOrderBelongToUser,
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      for (var json in baseResponse.data) {
        Order order = Order.fromMap(json);
        orders.add(order);
      }
    } catch (e) {
      log("error get all orders belong to user: $e");
    }

    return orders;
  }

  Future<List<OrderModel>> getAllOrders(
      List<String> filters, String sort) async {
    List<OrderModel> orders = [];
    try {
      final response = await apiServices.get(
        urlGetAllOrder,
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.message == 'ForbiddenError') {
        throw baseResponse.message.toString();
      }

      for (var json in baseResponse.data['orders']) {
        OrderModel order = OrderModel.fromMap(json);
        orders.add(order);
      }
    } catch (e) {
      log("error get all orders: $e");

      if (e == 'ForbiddenError') {
        rethrow;
      }
    }

    return orders;
  }

  Future<OrderDetailModel> getOrderDetail(int orderId) async {
    try {
      final response = await apiServices.get(
        '$urlGetDetailOrder/$orderId',
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      OrderDetailModel order = OrderDetailModel.fromMap(baseResponse.data);
      return order;
    } catch (e) {
      log("error get all orders: $e");
      rethrow;
    }
  }
}
