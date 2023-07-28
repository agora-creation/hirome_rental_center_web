import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/services/order.dart';

class OrderProvider with ChangeNotifier {
  OrderService orderService = OrderService();

  Future<String?> ordered({
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
        newCarts.add(cart.toMap());
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
