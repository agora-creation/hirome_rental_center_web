import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/shop.dart';

class AgentOrder3Screen extends StatefulWidget {
  final ShopModel shop;
  final List<CartModel> carts;

  const AgentOrder3Screen({
    required this.shop,
    required this.carts,
    super.key,
  });

  @override
  State<AgentOrder3Screen> createState() => _AgentOrder3ScreenState();
}

class _AgentOrder3ScreenState extends State<AgentOrder3Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
            size: 32.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '食器センター : 代理発注 - 発注内容確認',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
    );
  }
}
