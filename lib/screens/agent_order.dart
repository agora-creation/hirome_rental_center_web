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
          SizedBox(
            width: kFloorMapWidth,
            height: kFloorMapHeight,
            child: CanvasTouchDetector(
              gesturesToOverride: const [
                GestureType.onTapDown,
              ],
              builder: (context) {
                return CustomPaint(
                  painter: FloorMapPaint(context),
                );
              },
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

class FloorMapPaint extends CustomPainter {
  final BuildContext context;

  FloorMapPaint(this.context);

  void squarePaint(
    TouchyCanvas touchyCanvas,
    Canvas canvas, {
    required Color color,
    required String label,
    required bool bold,
    required double posLeft,
    required double posTop,
    required double width,
    required double height,
    Function(TapDownDetails)? onTapDown,
  }) {
    final fill = Paint()..color = color;
    touchyCanvas.drawRect(
      Rect.fromLTWH(posLeft, posTop, width, height),
      fill,
      onTapDown: onTapDown,
    );
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    touchyCanvas.drawRRect(
      RRect.fromLTRBR(
          posLeft, posTop, width + posLeft, height + posTop, Radius.zero),
      border,
      onTapDown: onTapDown,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: bold ? kFloorMapTextStyle : kFloorMapTextStyle2,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: kFloorMapWidth);
    double offsetX = posLeft + 2;
    double offsetY = posTop + 2;
    textPainter.paint(canvas, Offset(offsetX, offsetY));
  }

  @override
  void paint(Canvas canvas, Size size) {
    TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);
    //背景
    final paintBg = Paint()..color = Colors.grey.shade100;
    touchyCanvas.drawRect(
      const Rect.fromLTWH(0, 0, kFloorMapWidth, kFloorMapHeight),
      paintBg,
    );
    //65
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '65',
      bold: true,
      posLeft: 10,
      posTop: 10,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {
        showMessage(context, tapDetails.toString(), true);
      },
    );
    //階段
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '階段',
      bold: false,
      posLeft: 40,
      posTop: 10,
      width: 30,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //47
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '47',
      bold: true,
      posLeft: 70,
      posTop: 10,
      width: 40,
      height: 60,
      onTapDown: (tapDetails) {},
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
