import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class MonthField extends StatelessWidget {
  final DateTime value;
  final Function()? onTap;

  const MonthField({
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: kGreyColor.withOpacity(0.2),
      title: Text(
        dateText('yyyy/MM', value),
        style: const TextStyle(color: kGreyColor),
      ),
      trailing: const Icon(Icons.date_range, color: kGreyColor),
      onTap: onTap,
    );
  }
}
