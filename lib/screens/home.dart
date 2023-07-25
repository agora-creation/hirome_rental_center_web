import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/services/order.dart';
import 'package:hirome_rental_center_web/widgets/animation_background.dart';
import 'package:hirome_rental_center_web/widgets/custom_header.dart';
import 'package:hirome_rental_center_web/widgets/order_list.dart';

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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '注文日時 : ${dateText('yyyy/MM/dd HH:mm', widget.order.createdAt)}',
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 16,
              ),
            ),
            Text(
              'ステータス : ${widget.order.statusText()}',
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '注文した商品 : ',
              style: TextStyle(
                color: kGreyColor,
                fontSize: 16,
              ),
            ),
            Column(
              children: widget.order.carts.map((cart) {
                return CartList(cart: cart, viewDelivery: true);
              }).toList(),
            ),
            const SizedBox(height: 16),
            widget.order.status == 0
                ? CustomSmButton(
                    label: 'キャンセルする',
                    labelColor: kWhiteColor,
                    backgroundColor: kOrangeColor,
                    onPressed: () async {
                      String? error =
                          await widget.orderProvider.cancel(widget.order);
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, 'キャンセルに成功しました', true);
                      Navigator.pop(context);
                    },
                  )
                : Container(),
            widget.order.status == 1
                ? CustomSmButton(
                    label: '再注文する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error =
                          await widget.orderProvider.reCreate(widget.order);
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, '再注文に成功しました', true);
                      Navigator.pop(context);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
