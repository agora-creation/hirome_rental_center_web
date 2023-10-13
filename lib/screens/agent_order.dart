import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/screens/agent_order2.dart';
import 'package:hirome_rental_center_web/services/shop.dart';
import 'package:hirome_rental_center_web/widgets/floor_map.dart';
import 'package:hirome_rental_center_web/widgets/shop_list.dart';
import 'package:provider/provider.dart';

class AgentOrderScreen extends StatefulWidget {
  const AgentOrderScreen({super.key});

  @override
  State<AgentOrderScreen> createState() => _AgentOrderScreenState();
}

class _AgentOrderScreenState extends State<AgentOrderScreen> {
  ShopService shopService = ShopService();
  Future getShopNext(String tenantNumber) async {
    ShopModel? tenantShop = await shopService.selectTenant(tenantNumber);
    if (tenantShop != null) {
      if (!mounted) return;
      pushScreen(
        context,
        AgentOrder2Screen(shop: tenantShop),
      );
    } else {
      if (!mounted) return;
      showMessage(context, 'テナント番号が店舗に設定されておりません', false);
    }
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
          '食器センター : 代理注文 - 店舗選択',
          style: TextStyle(
            color: kBlackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          const Text(
            '注文する店舗をタップしてください',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          FloorMap(getShopNext: getShopNext),
          const SizedBox(height: 8),
          const Divider(height: 0, color: kGreyColor),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: shopService.streamList(),
              builder: (context, snapshot) {
                List<ShopModel> shops = [];
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    shops.add(ShopModel.fromSnapshot(doc));
                  }
                }
                if (shops.isEmpty) {
                  return const Center(
                    child: Text('注文できる店舗がありません'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 600),
                  shrinkWrap: true,
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    ShopModel shop = shops[index];
                    return ShopList(
                      shop: shop,
                      onTap: () async {
                        await orderProvider.clearCart();
                        await orderProvider.initCarts();
                        if (!mounted) return;
                        pushScreen(
                          context,
                          AgentOrder2Screen(shop: shop),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
