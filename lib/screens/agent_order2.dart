import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/services/product.dart';
import 'package:hirome_rental_center_web/widgets/product_list.dart';

class AgentOrder2Screen extends StatefulWidget {
  final ShopModel shop;

  const AgentOrder2Screen({
    required this.shop,
    super.key,
  });

  @override
  State<AgentOrder2Screen> createState() => _AgentOrder2ScreenState();
}

class _AgentOrder2ScreenState extends State<AgentOrder2Screen> {
  ProductService productService = ProductService();

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
          '食器センター : 代理発注 - 商品選択',
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
            const Text(
              '以下、注文したい商品の数量を選択してください',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: kGreyColor),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: productService.streamList(),
                builder: (context, snapshot) {
                  List<ProductModel> products = [];
                  if (snapshot.hasData) {
                    for (DocumentSnapshot<Map<String, dynamic>> doc
                        in snapshot.data!.docs) {
                      products.add(ProductModel.fromSnapshot(doc));
                    }
                  }
                  if (products.isEmpty) {
                    return const Center(
                      child: Text('商品がありません'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      ProductModel product = products[index];
                      return ProductList(product: product);
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
