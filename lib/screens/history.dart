import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/services/order.dart';
import 'package:hirome_rental_center_web/widgets/cart_list.dart';
import 'package:hirome_rental_center_web/widgets/custom_sm_button.dart';
import 'package:hirome_rental_center_web/widgets/date_range_field.dart';
import 'package:hirome_rental_center_web/widgets/history_list_tile.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '食器センター : 受注履歴',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 400),
        child: Column(
          children: [
            DateRangeField(
              start: orderProvider.searchStart,
              end: orderProvider.searchEnd,
              onTap: () async {
                var selected = await showDataRangePickerDialog(
                  context,
                  orderProvider.searchStart,
                  orderProvider.searchEnd,
                );
                if (selected != null &&
                    selected.first != null &&
                    selected.last != null) {
                  orderProvider.searchChange(selected.first!, selected.last!);
                }
              },
            ),
            const Divider(height: 0, color: kGreyColor),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: orderService.streamHistoryList(
                  searchStart: orderProvider.searchStart,
                  searchEnd: orderProvider.searchEnd,
                ),
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
                      child: Text('注文がありません'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      OrderModel order = orders[index];
                      return HistoryListTile(
                        order: order,
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => OrderDetailsDialog(
                            orderProvider: orderProvider,
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
    );
  }
}

class OrderDetailsDialog extends StatefulWidget {
  final OrderProvider orderProvider;
  final OrderModel order;

  const OrderDetailsDialog({
    required this.orderProvider,
    required this.order,
    super.key,
  });

  @override
  State<OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  List<CartModel> carts = [];

  void _init() async {
    if (mounted) {
      setState(() {
        carts = widget.order.carts;
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
    return AlertDialog(
      insetPadding: const EdgeInsets.all(100),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                '納品数量を変更して、再受注してください',
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
              '注文された店舗 : ${widget.order.shopName}',
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
            const SizedBox(height: 8),
            const Text(
              '注文された商品',
              style: TextStyle(fontSize: 16),
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
                  );
                },
              ),
            ),
            const Divider(height: 1, color: kGreyColor),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomSmButton(
                    label: 'キャンセルする',
                    labelColor: kWhiteColor,
                    backgroundColor: kOrangeColor,
                    onPressed: () async {
                      String? error = await widget.orderProvider.cancel(
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
                    label: '再受注する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await widget.orderProvider.reOrdered(
                        order: widget.order,
                        carts: carts,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, '再受注に成功しました', true);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}