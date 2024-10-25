import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/services/order.dart';
import 'package:hirome_rental_center_web/services/product.dart';
import 'package:hirome_rental_center_web/services/shop.dart';
import 'package:hirome_rental_center_web/widgets/custom_sm_button.dart';
import 'package:hirome_rental_center_web/widgets/date_range_field.dart';
import 'package:hirome_rental_center_web/widgets/order_product_total_list.dart';
import 'package:hirome_rental_center_web/widgets/shop_dropdown_button.dart';
import 'package:provider/provider.dart';

class OrderProductTotalScreen extends StatefulWidget {
  const OrderProductTotalScreen({super.key});

  @override
  State<OrderProductTotalScreen> createState() =>
      _OrderProductTotalScreenState();
}

class _OrderProductTotalScreenState extends State<OrderProductTotalScreen> {
  OrderService orderService = OrderService();
  ProductService productService = ProductService();
  ShopService shopService = ShopService();
  List<ProductModel> products = [];
  List<ShopModel> shops = [];

  void _init() async {
    List<ProductModel> tmpProducts = await productService.selectList();
    List<ShopModel> tmpShops = await shopService.selectList();
    setState(() {
      products = tmpProducts;
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
          '食器センター : 受注商品集計',
          style: TextStyle(
            color: kBlackColor,
            fontSize: 24,
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
                  Map<String, int> totalMap = {};
                  if (snapshot.hasData) {
                    for (DocumentSnapshot<Map<String, dynamic>> doc
                        in snapshot.data!.docs) {
                      OrderModel order = OrderModel.fromSnapshot(doc);
                      for (CartModel cart in order.carts) {
                        String key = cart.number;
                        if (totalMap[key] == null) {
                          totalMap[key] = cart.deliveryQuantity;
                        } else {
                          totalMap[key] = int.parse('${totalMap[key]}') +
                              cart.deliveryQuantity;
                        }
                      }
                    }
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            ProductModel product = products[index];
                            return OrderProductTotalList(
                              product: product,
                              total: totalMap[product.number],
                            );
                          },
                        ),
                      ),
                      CustomSmButton(
                        label: '印刷する',
                        labelColor: kWhiteColor,
                        backgroundColor: kGreyColor,
                        onPressed: () async => await orderProvider.totalPrint(
                          products: products,
                          totalMap: totalMap,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
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
