import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';

class CartList2 extends StatelessWidget {
  final CartModel cart;

  const CartList2({
    required this.cart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '商品番号 : ${cart.number}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 16,
                ),
              ),
              Text(
                cart.name,
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '納品数量',
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 16,
                ),
              ),
              Text(
                '${cart.deliveryQuantity}${cart.unit}',
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
