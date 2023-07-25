import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/order.dart';

class OrderList extends StatelessWidget {
  final OrderModel order;
  final Function()? onTap;

  const OrderList({
    required this.order,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '注文日時 : ${dateText('yyyy/MM/dd HH:mm', order.createdAt)}',
                    style: const TextStyle(
                      color: kGreyColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    order.shopName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(order.cartsText()),
            ],
          ),
        ),
      ),
    );
  }
}
