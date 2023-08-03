import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final String unit;
  final Function()? onRemoved;
  final Function()? onAdded;

  const QuantityButton({
    this.quantity = 0,
    this.unit = '',
    this.onRemoved,
    this.onAdded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kBlueColor),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onRemoved,
            icon: const Icon(
              Icons.remove,
              color: kBlueColor,
              size: 26,
            ),
          ),
          Text(
            '$quantity $unit',
            style: const TextStyle(
              color: kBlueColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onAdded,
            icon: const Icon(
              Icons.add,
              color: kBlueColor,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
