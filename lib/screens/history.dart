import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/services/order.dart';
import 'package:hirome_rental_center_web/services/shop.dart';
import 'package:hirome_rental_center_web/widgets/cart_list.dart';
import 'package:hirome_rental_center_web/widgets/custom_lg_button.dart';
import 'package:hirome_rental_center_web/widgets/date_range_field.dart';
import 'package:hirome_rental_center_web/widgets/history_list_tile.dart';
import 'package:hirome_rental_center_web/widgets/shop_dropdown_button.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  OrderService orderService = OrderService();
  ShopService shopService = ShopService();
  List<ShopModel> shops = [];

  void _init() async {
    List<ShopModel> tmpShops = await shopService.selectList();
    setState(() {
      shops = tmpShops;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

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
          style: TextStyle(
            color: kBlackColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
              size: 32,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 600),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DateRangeField(
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
                        var diff = selected.last!.difference(selected.first!);
                        int diffDays = diff.inDays;
                        if (diffDays > 31) {
                          if (!mounted) return;
                          showMessage(context, '1ヵ月以上の範囲が選択されています', false);
                          return;
                        }
                        orderProvider.searchDateChange(
                          selected.first!,
                          selected.last!,
                        );
                      }
                    },
                  ),
                ),
                ShopDropdownButton(
                  shops: shops,
                  value: orderProvider.searchShop,
                  onChanged: (value) {
                    orderProvider.searchShopChange(value);
                  },
                ),
              ],
            ),
            const Divider(height: 0, color: kGreyColor),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: orderService.streamHistoryList(
                  searchStart: orderProvider.searchStart,
                  searchEnd: orderProvider.searchEnd,
                  searchShop: orderProvider.searchShop,
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
                      child: Text(
                        '注文がありません',
                        style: TextStyle(fontSize: 24),
                      ),
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
                  '納品数量を変更して、再受注してください',
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
              '注文日時 : ${dateText('yyyy/MM/dd HH:mm', widget.order.createdAt)}／注文された店舗 : ${widget.order.shopName}／ステータス : ${widget.order.statusText()}',
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
                    onRemoved10: () {
                      if (cart.deliveryQuantity == 0) return;
                      setState(() {
                        if (cart.deliveryQuantity <= 10) {
                          cart.deliveryQuantity = 0;
                        } else {
                          cart.deliveryQuantity -= 10;
                        }
                      });
                    },
                    onAdded: () {
                      setState(() {
                        cart.deliveryQuantity += 1;
                      });
                    },
                    onAdded10: () {
                      setState(() {
                        cart.deliveryQuantity += 10;
                      });
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1, color: kGreyColor),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 500,
                child: CustomLgButton(
                  label: '上記内容で再受注する',
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
          ],
        ),
      ),
    );
  }
}
