import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class DateRangeField extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final Function()? onTap;

  const DateRangeField({
    required this.start,
    required this.end,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${dateText('yyyy/MM/dd', start)}～${dateText('yyyy/MM/dd', end)}',
        style: const TextStyle(color: kGreyColor),
      ),
      trailing: const Icon(Icons.date_range, color: kGreyColor),
      onTap: onTap,
    );
  }
}
