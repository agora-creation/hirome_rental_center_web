import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/product.dart';

class OrderProductTotalList extends StatelessWidget {
  final ProductModel product;
  final int? total;

  const OrderProductTotalList({
    required this.product,
    this.total = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0 || total == null) return Container();
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                  color: kBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '合計納品数量',
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '$total${product.unit}',
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 16,
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
