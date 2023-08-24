import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/screens/agent_order.dart';
import 'package:hirome_rental_center_web/screens/history.dart';
import 'package:hirome_rental_center_web/screens/order_product_total.dart';
import 'package:hirome_rental_center_web/screens/settings.dart';
import 'package:hirome_rental_center_web/services/order.dart';
import 'package:hirome_rental_center_web/services/product.dart';
import 'package:hirome_rental_center_web/widgets/animation_background.dart';
import 'package:hirome_rental_center_web/widgets/cart_list.dart';
import 'package:hirome_rental_center_web/widgets/cart_wash_list.dart';
import 'package:hirome_rental_center_web/widgets/custom_header.dart';
import 'package:hirome_rental_center_web/widgets/custom_lg_button.dart';
import 'package:hirome_rental_center_web/widgets/link_text.dart';
import 'package:hirome_rental_center_web/widgets/order_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimationBackground(),
          SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  title: '食器センター : 受注未処理',
                  actions: [
                    GestureDetector(
                      onTap: () => showBottomUpScreen(
                        context,
                        const AgentOrderScreen(),
                      ),
                      child: const Text(
                        '代理注文',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () => showBottomUpScreen(
                        context,
                        const HistoryScreen(),
                      ),
                      child: const Text(
                        '受注履歴',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () => showBottomUpScreen(
                        context,
                        const OrderProductTotalScreen(),
                      ),
                      child: const Text(
                        '受注商品集計',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () => showBottomUpScreen(
                        context,
                        const SettingsScreen(),
                      ),
                      child: const Text(
                        '設定',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '以下の注文をタップしてください',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: orderService.streamList(),
                    builder: (context, snapshot) {
                      List<OrderModel> orders = [];
                      if (snapshot.hasData) {
                        for (DocumentSnapshot<Map<String, dynamic>> doc
                            in snapshot.data!.docs) {
                          orders.add(OrderModel.fromSnapshot(doc));
                        }
                      }
                      if (orders.isEmpty) {
                        return const Center(
                          child: Text(
                            '未処理の注文がありません',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 200),
                        shrinkWrap: true,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          OrderModel order = orders[index];
                          return OrderList(
                            order: order,
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => OrderDetailsDialog(
                                order: order,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsDialog extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsDialog({
    required this.order,
    super.key,
  });

  @override
  State<OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  ProductService productService = ProductService();
  List<CartModel> carts = [];
  List<CartModel> cartsWash = [];

  void _init() async {
    List<ProductModel> products = await productService.selectList(category: 9);
    List<CartModel> tmpCartsWash = [];
    for (ProductModel product in products) {
      tmpCartsWash.add(CartModel.fromMap({
        'id': product.id,
        'number': product.number,
        'name': product.name,
        'invoiceNumber': product.invoiceNumber,
        'price': product.price,
        'unit': product.unit,
        'category': product.category,
        'requestQuantity': 0,
        'deliveryQuantity': 0,
      }));
    }
    if (mounted) {
      setState(() {
        carts = widget.order.carts;
        cartsWash = tmpCartsWash;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                const Text(
                  '納品数量を変更して、受注してください',
                  style: TextStyle(
                    color: kGreyColor,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '注文日時 : ${dateText('yyyy/MM/dd HH:mm', widget.order.createdAt)}',
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 18,
              ),
            ),
            Text(
              '注文された店舗 : ${widget.order.shopName}',
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '注文された商品',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, color: kGreyColor),
            SizedBox(
              height: 350,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  CartModel cart = carts[index];
                  return CartList(
                    cart: cart,
                    onRemoved: () {
                      if (cart.deliveryQuantity == 0) return;
                      setState(() {
                        cart.deliveryQuantity -= 1;
                      });
                    },
                    onAdded: () {
                      setState(() {
                        cart.deliveryQuantity += 1;
                      });
                    },
                    onQuantity: () {},
                  );
                },
              ),
            ),
            const Divider(height: 1, color: kGreyColor),
            const SizedBox(height: 16),
            const Text(
              '▼ 洗浄を追加する',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Row(
              children: cartsWash.map((cart) {
                return Expanded(
                  child: CartWashList(
                    cart: cart,
                    onRemoved: () {
                      if (cart.deliveryQuantity == 0) return;
                      setState(() {
                        cart.deliveryQuantity -= 1;
                      });
                    },
                    onAdded: () {
                      setState(() {
                        cart.deliveryQuantity += 1;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 500,
                child: CustomLgButton(
                  label: '上記内容で受注する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () async {
                    String? error = await orderProvider.ordered(
                      order: widget.order,
                      carts: carts,
                      cartsWash: cartsWash,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '受注に成功しました', true);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const Center(
              child: Text(
                '※レシートが発行されます',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinkText(
                  label: 'この注文をキャンセル',
                  labelColor: kRedColor,
                  onTap: () async {
                    String? error = await orderProvider.cancel(
                      widget.order,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, 'キャンセルに成功しました', true);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
