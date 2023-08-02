import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/services/order.dart';

class OrderProvider with ChangeNotifier {
  OrderService orderService = OrderService();

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
}
