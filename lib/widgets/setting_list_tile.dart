import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class SettingListTile extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool topBorder;
  final Function()? onTap;

  const SettingListTile({
    required this.iconData,
    required this.label,
    this.topBorder = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: topBorder
            ? const Border(
                top: BorderSide(color: kGrey2Color),
                bottom: BorderSide(color: kGrey2Color),
              )
            : const Border(
                bottom: BorderSide(color: kGrey2Color),
              ),
      ),
      child: ListTile(
        leading: Icon(iconData, color: kGrey2Color),
        title: Text(
          label,
          style: const TextStyle(color: kBlackColor),
        ),
        trailing: const Icon(Icons.chevron_right, color: kGrey2Color),
        onTap: onTap,
      ),
    );
  }
}
