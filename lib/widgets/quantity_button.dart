import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final String unit;
  final Function()? onRemoved;
  final Function()? onRemoved10;
  final Function()? onAdded;
  final Function()? onAdded10;

  const QuantityButton({
    this.quantity = 0,
    this.unit = '',
    this.onRemoved,
    this.onRemoved10,
    this.onAdded,
    this.onAdded10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  size: 28,
                ),
              ),
              Text(
                '$quantity $unit',
                style: const TextStyle(
                  color: kBlueColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onAdded,
                icon: const Icon(
                  Icons.add,
                  color: kBlueColor,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '$quantity $unit',
              style: const TextStyle(
                color: Colors.transparent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
