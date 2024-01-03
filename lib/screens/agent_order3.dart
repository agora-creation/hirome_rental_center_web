import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/screens/home.dart';
import 'package:hirome_rental_center_web/widgets/cart_list2.dart';
import 'package:hirome_rental_center_web/widgets/custom_lg_button.dart';
import 'package:hirome_rental_center_web/widgets/link_text.dart';
import 'package:provider/provider.dart';

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
  bool buttonDisabled = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '食器センター : 代理注文 - 注文確認',
          style: TextStyle(
            color: kBlackColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '注文の内容を確認してください\n間違いなければ『注文する』ボタンを押してください',
              style: TextStyle(
                color: kRedColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '注文する店舗 : ${widget.shop.name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text('注文する商品'),
            const Divider(height: 1, color: kGreyColor),
            SizedBox(
              height: 350,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.carts.length,
                itemBuilder: (context, index) {
                  CartModel cart = widget.carts[index];
                  return CartList2(cart: cart);
                },
              ),
            ),
            const Divider(height: 1, color: kGreyColor),
            const SizedBox(height: 32),
            buttonDisabled
                ? const CustomLgButton(
                    label: '注文する',
                    labelColor: kWhiteColor,
                    backgroundColor: kGreyColor,
                    onPressed: null,
                  )
                : CustomLgButton(
                    label: '注文する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      setState(() {
                        buttonDisabled = true;
                      });
                      String? error = await orderProvider.create(
                        shop: widget.shop,
                        carts: widget.carts,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        setState(() {
                          buttonDisabled = false;
                        });
                        return;
                      }
                      await orderProvider.clearCart();
                      await orderProvider.initCarts();
                      if (!mounted) return;
                      showMessage(context, '注文に成功しました', true);
                      pushReplacementScreen(context, const HomeScreen());
                    },
                  ),
            const Center(
              child: Text(
                '※レシートが発行されます',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: LinkText(
                label: 'カートを空にする',
                labelColor: kRedColor,
                onTap: () async {
                  await orderProvider.clearCart();
                  await orderProvider.initCarts();
                  if (!mounted) return;
                  showMessage(context, 'カートを空にしました', true);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
