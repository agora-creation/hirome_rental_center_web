import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/order.dart';

class HistoryListTile extends StatelessWidget {
  final OrderModel order;
  final Function()? onTap;

  const HistoryListTile({
    required this.order,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kGreyColor)),
        ),
        child: ListTile(
          title: Text(
            order.cartsText(),
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '注文日時 : ${dateText('yyyy/MM/dd HH:mm', order.createdAt)}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
            ),
          ),
          trailing: order.statusChip(),
        ),
      ),
    );
  }
}
