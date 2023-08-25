import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';

class CartWashList extends StatelessWidget {
  final CartModel cart;
  final Function()? onRemoved;
  final Function()? onRemoved10;
  final Function()? onAdded;
  final Function()? onAdded10;

  const CartWashList({
    required this.cart,
    this.onRemoved,
    this.onRemoved10,
    this.onAdded,
    this.onAdded10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kBlueColor),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            onPressed: onRemoved,
                            icon: const Icon(
                              Icons.remove,
                              color: kBlueColor,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '${cart.deliveryQuantity}${cart.unit}',
                            style: const TextStyle(
                              color: kBlueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            onPressed: onAdded,
                            icon: const Icon(
                              Icons.add,
                              color: kBlueColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: onRemoved10,
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(
                            side: BorderSide(color: kBlueColor),
                          ),
                        ),
                        child: const Text(
                          '－10',
                          style: TextStyle(
                            color: kBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '${cart.deliveryQuantity}${cart.unit}',
                          style: const TextStyle(
                            color: Colors.transparent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onAdded10,
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(
                            side: BorderSide(color: kBlueColor),
                          ),
                        ),
                        child: const Text(
                          '＋10',
                          style: TextStyle(
                            color: kBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
