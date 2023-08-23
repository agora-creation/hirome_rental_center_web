import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const CustomHeader({
    required this.title,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: kWhiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(children: actions),
        ],
      ),
    );
  }
}
