import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/providers/order.dart';
import 'package:hirome_rental_center_web/screens/agent_order2.dart';
import 'package:hirome_rental_center_web/services/shop.dart';
import 'package:hirome_rental_center_web/widgets/shop_list.dart';
import 'package:provider/provider.dart';
import 'package:touchable/touchable.dart';

class AgentOrderScreen extends StatefulWidget {
  const AgentOrderScreen({super.key});

  @override
  State<AgentOrderScreen> createState() => _AgentOrderScreenState();
}

class _AgentOrderScreenState extends State<AgentOrderScreen> {
  ShopService shopService = ShopService();

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
          Center(
            child: CanvasTouchDetector(
              gesturesToOverride: const [
                GestureType.onTapDown,
              ],
              builder: (context) => CustomPaint(
                size: const Size(kFloorWidth, kFloorHeight),
                painter: FloorPaint(context),
              ),
            ),
          ),
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

class FloorPaint extends CustomPainter {
  final BuildContext context;

  FloorPaint(this.context);

  @override
  void paint(Canvas _canvas, Size size) {
    TouchyCanvas canvas = TouchyCanvas(context, _canvas);
    const fTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    //背景
    final paintBg = Paint()..color = Colors.grey.shade100;
    canvas.drawRect(
        const Rect.fromLTWH(0, 0, kFloorWidth, kFloorHeight), paintBg,
        onTapDown: (_) {});
    //65
    final paint65 = Paint()..color = Colors.brown.shade300;
    final paint65b = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(
      const Rect.fromLTWH(10, 10, 30, 50),
      paint65,
      onTapDown: (_) {
        showMessage(context, 'テナント番号『65』が押されたよ！', true);
      },
    );
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(10, 10, 40, 60),
      paint65b,
      onTapDown: (_) {
        showMessage(context, 'テナント番号『65』が押されたよ！', true);
      },
    );
    const textSpan65 = TextSpan(
      text: '65',
      style: fTextStyle,
    );
    final textPainter65 = TextPainter(
      text: textSpan65,
      textDirection: TextDirection.ltr,
    );
    textPainter65.layout(minWidth: 0, maxWidth: 1000);
    textPainter65.paint(_canvas, const Offset(15, 25));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
