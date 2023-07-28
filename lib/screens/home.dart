import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/services/order.dart';
import 'package:hirome_rental_center_web/services/product.dart';
import 'package:hirome_rental_center_web/widgets/animation_background.dart';
import 'package:hirome_rental_center_web/widgets/cart_list.dart';
import 'package:hirome_rental_center_web/widgets/custom_header.dart';
import 'package:hirome_rental_center_web/widgets/custom_sm_button.dart';
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
                      onTap: () {},
                      child: const Text(
                        '代理発注',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        '受注履歴',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        '設定',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '以下の注文に対応してください',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
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
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
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

  void _init() async {
    carts.clear();
    List<ProductModel> products = await productService.selectList(category: 9);
    carts = widget.order.carts;
    for (ProductModel product in products) {
      carts.add(CartModel.fromMap({
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
    setState(() {});
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
      insetPadding: const EdgeInsets.all(100),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  '納品数量を確定して、受注してください',
                  style: TextStyle(
                    color: kGreyColor,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '注文日時 : ${dateText('yyyy/MM/dd HH:mm', widget.order.createdAt)}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 16,
                ),
              ),
              Text(
                '発注元店舗 : ${widget.order.shopName}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '注文された商品',
                style: TextStyle(fontSize: 16),
              ),
              Column(
                children: carts.map((cart) {
                  return CartList(
                    cart: cart,
                    onRemoved: () {
                      if (cart.deliveryQuantity < 0) return;
                      setState(() {
                        cart.deliveryQuantity -= 1;
                      });
                    },
                    onAdded: () {
                      setState(() {
                        cart.deliveryQuantity += 1;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomSmButton(
                      label: 'キャンセルする',
                      labelColor: kWhiteColor,
                      backgroundColor: kOrangeColor,
                      onPressed: () async {
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
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomSmButton(
                      label: '受注する',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () async {
                        String? error = await orderProvider.ordered(
                          order: widget.order,
                          carts: carts,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
