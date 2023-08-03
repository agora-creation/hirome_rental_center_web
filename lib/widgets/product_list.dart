import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/widgets/custom_image.dart';

class ProductList extends StatelessWidget {
  final ProductModel product;
  final List<CartModel> carts;
  final Function()? onTap;

  const ProductList({
    required this.product,
    required this.carts,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var contain = carts.where((e) => e.number == product.number);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kGreyColor)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: CustomImage(product.image),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '商品番号 : ${product.number}',
                            style: const TextStyle(
                              color: kGreyColor,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          contain.isNotEmpty
              ? Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: kBlackColor.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        '${contain.first.requestQuantity}${contain.first.unit} 選択中',
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
