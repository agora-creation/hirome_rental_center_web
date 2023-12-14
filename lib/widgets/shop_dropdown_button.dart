import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/models/shop.dart';

class ShopDropdownButton extends StatelessWidget {
  final List<ShopModel> shops;
  final String? value;
  final Function(String?)? onChanged;

  const ShopDropdownButton({
    required this.shops,
    this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];
    items.add(const DropdownMenuItem(
      value: null,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Text(
          '店舗未選択',
          style: TextStyle(fontSize: 18),
        ),
      ),
    ));
    for (ShopModel shop in shops) {
      items.add(DropdownMenuItem(
        value: shop.number,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            shop.name,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ));
    }
    return DropdownButton(
      items: items,
      value: value,
      onChanged: onChanged,
      hint: const Padding(
        padding: EdgeInsets.all(4),
        child: Text(
          '店舗未選択',
          style: TextStyle(fontSize: 18),
        ),
      ),
      elevation: 0,
      underline: Container(),
    );
  }
}
