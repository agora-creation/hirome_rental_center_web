import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/services/cart.dart';
import 'package:hirome_rental_center_web/services/order.dart';

class OrderProvider with ChangeNotifier {
  CartService cartService = CartService();
  OrderService orderService = OrderService();
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;

  DateTime searchStart = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime searchEnd = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    1,
  ).add(const Duration(days: -1));

  void searchChange(DateTime start, DateTime end) {
    searchStart = start;
    searchEnd = end;
    notifyListeners();
  }

  Future<String?> create({
    ShopModel? shop,
    List<CartModel>? carts,
  }) async {
    String? error;
    if (shop == null) return '注文に失敗しました';
    if (carts == null) return '注文に失敗しました';
    if (carts.isEmpty) return '注文に失敗しました';
    try {
      String id = orderService.id();
      String dateTime = dateText('yyyyMMddHHmmss', DateTime.now());
      String number = '${shop.number}-$dateTime';
      List<Map> newCarts = [];
      for (CartModel cart in carts) {
        newCarts.add(cart.toMap());
      }
      orderService.create({
        'id': id,
        'number': number,
        'shopId': shop.id,
        'shopNumber': shop.number,
        'shopName': shop.name,
        'shopInvoiceName': shop.invoiceName,
        'carts': newCarts,
        'status': 1,
        'updatedAt': DateTime.now(),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '注文に失敗しました';
    }
    return error;
  }

  Future<String?> ordered({
    OrderModel? order,
    List<CartModel>? carts,
    List<CartModel>? cartsWash,
  }) async {
    String? error;
    if (order == null) return '受注に失敗しました';
    if (carts == null) return '受注に失敗しました';
    if (carts.isEmpty) return '受注に失敗しました';
    if (cartsWash == null) return '受注に失敗しました';
    if (cartsWash.isEmpty) return '受注に失敗しました';
    try {
      List<Map> newCarts = [];
      for (CartModel cart in carts) {
        if (cart.deliveryQuantity > 0) {
          newCarts.add(cart.toMap());
        }
      }
      for (CartModel cart in cartsWash) {
        if (cart.deliveryQuantity > 0) {
          newCarts.add(cart.toMap());
        }
      }
      orderService.update({
        'id': order.id,
        'carts': newCarts,
        'status': 1,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      error = '受注に失敗しました';
    }
    return error;
  }

  Future<String?> reOrdered({
    OrderModel? order,
    List<CartModel>? carts,
  }) async {
    String? error;
    if (order == null) return '受注に失敗しました';
    if (carts == null) return '受注に失敗しました';
    if (carts.isEmpty) return '受注に失敗しました';
    try {
      List<Map> newCarts = [];
      for (CartModel cart in carts) {
        if (cart.deliveryQuantity > 0) {
          newCarts.add(cart.toMap());
        }
      }
      orderService.update({
        'id': order.id,
        'carts': newCarts,
        'status': 1,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      error = '再受注に失敗しました';
    }
    return error;
  }

  Future<String?> cancel(OrderModel order) async {
    String? error;
    try {
      orderService.update({
        'id': order.id,
        'status': 9,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      error = 'キャンセルに失敗しました';
    }
    return error;
  }

  Future initCarts() async {
    _carts = await cartService.get();
    notifyListeners();
  }

  Future addCarts(ProductModel product, int requestQuantity) async {
    await cartService.add(product, requestQuantity);
  }

  Future removeCart(CartModel cart) async {
    await cartService.remove(cart);
  }

  Future clearCart() async {
    await cartService.clear();
  }
}