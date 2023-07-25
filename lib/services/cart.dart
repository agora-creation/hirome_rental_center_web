import 'dart:convert';

import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/product.dart';

class CartService {
  Future<List<CartModel>> get() async {
    List<CartModel> ret = [];
    List<String>? jsonData = await getPrefsList('carts');
    if (jsonData != null) {
      ret = jsonData.map((e) {
        return CartModel.fromMap(json.decode(e));
      }).toList();
    }
    return ret;
  }

  Future add(ProductModel product, int requestQuantity) async {
    List<CartModel> carts = await get();
    bool isExist = false;
    for (CartModel cart in carts) {
      if (cart.number == product.number) {
        isExist = true;
        cart.requestQuantity = requestQuantity;
      }
    }
    if (!isExist) {
      carts.add(CartModel.fromMap({
        'id': product.id,
        'number': product.number,
        'name': product.name,
        'invoiceNumber': product.invoiceNumber,
        'price': product.price,
        'unit': product.unit,
        'category': product.category,
        'requestQuantity': requestQuantity,
        'deliveryQuantity': requestQuantity,
      }));
    }
    List<String> jsonData = carts.map((e) {
      return json.encode(e.toMap());
    }).toList();
    await setPrefsList('carts', jsonData);
  }

  Future remove(CartModel cart) async {
    List<CartModel> carts = await get();
    carts.removeWhere((e) => e.id == cart.id);
    List<String> jsonData = carts.map((e) {
      return json.encode(e.toMap());
    }).toList();
    await setPrefsList('carts', jsonData);
  }

  Future clear() async {
    await setPrefsList('carts', []);
  }
}
