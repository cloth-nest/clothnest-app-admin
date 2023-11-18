import 'dart:developer';

import 'package:grocery/data/environment.dart';
import 'package:grocery/data/interfaces/i_service_api.dart';
import 'package:grocery/data/models/cart.dart';
import 'package:grocery/data/network/base_api_service.dart';
import 'package:grocery/data/network/network_api_service.dart';
import 'package:grocery/data/response/base_response.dart';
import 'package:grocery/presentation/services/app_data.dart';

class CartRepository extends IServiceAPI {
  String urlGetAllCart = "cart/get-all";
  String urlAddToCart = "cart/add";
  String urlRemoveFromCart = "cart/remove";

  final BaseApiServices apiServices = NetworkApiService();
  final AppData _appData;

  CartRepository(this._appData) {
    urlGetAllCart = localURL + urlGetAllCart;
    urlAddToCart = localURL + urlAddToCart;
    urlRemoveFromCart = localURL + urlRemoveFromCart;
  }

  @override
  Cart convertToObject(value) {
    return Cart.fromJson(value);
  }

  Future<List<Cart>?> getAllCarts() async {
    List<Cart> carts = [];

    var response;

    try {
      response = await apiServices.get(
        urlGetAllCart,
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      for (var json in baseResponse.data) {
        Cart cart = Cart.fromMap(json);
        carts.add(cart);
      }

      return carts;
    } catch (e) {
      log("error get all carts: $e");
    }

    return null;
  }

  Future<Cart?> getCartById(String idProduct) async {
    Cart cart;

    var response;

    try {
      response = await apiServices.get(
        urlGetAllCart,
        _appData.headers,
      );

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      for (var json in baseResponse.data) {
        cart = Cart.fromMap(json);
        if (cart.product.id == idProduct) {
          return cart;
        }
      }
    } catch (e) {
      log("error get cart by id: $e");
    }

    return null;
  }

  Future<void> addToCart(String idProduct, int quantity) async {
    try {
      await apiServices.post(
        urlAddToCart,
        {
          "productId": idProduct,
          "quantity": quantity,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error add to cart: $e");
    }
  }

  Future<void> removeFromCart(String idProduct, int quantity) async {
    try {
      await apiServices.post(
        urlRemoveFromCart,
        {
          "productId": idProduct,
          "quantity": quantity,
        },
        _appData.headers,
      );
    } catch (e) {
      log("error remove from cart: $e");
    }
  }
}
