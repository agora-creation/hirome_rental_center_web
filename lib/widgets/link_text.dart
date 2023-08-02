import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Function()? onTap;

  const LinkText({
    required this.label,
    required this.labelColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontSize: 18,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
