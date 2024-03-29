import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/screens/agent_order3.dart';
import 'package:hirome_rental_center_web/services/product.dart';
import 'package:hirome_rental_center_web/widgets/cart_list2.dart';
import 'package:hirome_rental_center_web/widgets/custom_image.dart';
import 'package:hirome_rental_center_web/widgets/custom_lg_button.dart';
import 'package:hirome_rental_center_web/widgets/link_text.dart';
import 'package:hirome_rental_center_web/widgets/product_list.dart';
import 'package:hirome_rental_center_web/widgets/quantity_button.dart';
import 'package:provider/provider.dart';

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
          '食器センター : 代理注文 - 商品選択',
          style: TextStyle(
            color: kBlackColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 600),
            child: Column(
              children: [
                Text(
                  '注文する店舗 : ${widget.shop.name}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 4),
                const Text(
                  '注文する商品を選択してください',
                  style: TextStyle(fontSize: 18),
                ),
                orderProvider.carts.isNotEmpty
                    ? const SizedBox(height: 8)
                    : Container(),
                orderProvider.carts.isNotEmpty
                    ? CustomLgButton(
                        label: '注文に進む',
                        labelColor: kWhiteColor,
                        backgroundColor: kBlueColor,
                        onPressed: () => pushScreen(
                          context,
                          AgentOrder3Screen(
                            shop: widget.shop,
                            carts: orderProvider.carts,
                          ),
                        ),
                      )
                    : Container(),
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
                          return ProductList(
                            product: product,
                            carts: orderProvider.carts,
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => ProductDetailsDialog(
                                orderProvider: orderProvider,
                                product: product,
                              ),
                            ).then((value) {
                              orderProvider.initCarts();
                            }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 400,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: orderProvider.carts.map((cart) {
                      return CartList2(cart: cart);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsDialog extends StatefulWidget {
  final OrderProvider orderProvider;
  final ProductModel product;

  const ProductDetailsDialog({
    required this.orderProvider,
    required this.product,
    super.key,
  });

  @override
  State<ProductDetailsDialog> createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog> {
  int requestQuantity = 0;
  CartModel? cart;

  void _init() async {
    int tmpRequestQuantity = 0;
    for (CartModel cartModel in widget.orderProvider.carts) {
      if (cartModel.number == widget.product.number) {
        tmpRequestQuantity = cartModel.requestQuantity;
        cart = cartModel;
      }
    }
    setState(() {
      requestQuantity = tmpRequestQuantity;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: CustomImage(widget.product.image),
          ),
          const SizedBox(height: 8),
          Text(
            '商品番号 : ${widget.product.number}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
            ),
          ),
          Text(
            widget.product.name,
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          QuantityButton(
            quantity: requestQuantity,
            unit: widget.product.unit,
            onRemoved: () {
              if (requestQuantity == 0) return;
              setState(() {
                requestQuantity -= 1;
              });
            },
            onRemoved10: () {
              if (requestQuantity == 0) return;
              setState(() {
                if (requestQuantity <= 10) {
                  requestQuantity = 0;
                } else {
                  requestQuantity -= 10;
                }
              });
            },
            onAdded: () {
              setState(() {
                requestQuantity += 1;
              });
            },
            onAdded10: () {
              setState(() {
                requestQuantity += 10;
              });
            },
          ),
          const SizedBox(height: 8),
          CustomLgButton(
            label: cart != null ? '数量を変更する' : 'カートに入れる',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              if (requestQuantity > 0) {
                await widget.orderProvider.addCarts(
                  widget.product,
                  requestQuantity,
                );
              } else if (cart != null) {
                await widget.orderProvider.removeCart(cart!);
              }
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
          cart != null
              ? Center(
                  child: LinkText(
                    label: 'カートから削除する',
                    labelColor: kRedColor,
                    onTap: () async {
                      if (cart == null) return;
                      await widget.orderProvider.removeCart(cart!);
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                  ),
                )
              : Container(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
