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
    //55
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '55',
      bold: true,
      posLeft: 110,
      posTop: 10,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //56
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '56',
      bold: true,
      posLeft: 140,
      posTop: 10,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //57
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '57',
      bold: true,
      posLeft: 210,
      posTop: 10,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //58
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '58',
      bold: true,
      posLeft: 240,
      posTop: 10,
      width: 50,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //60
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '60',
      bold: true,
      posLeft: 210,
      posTop: 40,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //59
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '59',
      bold: true,
      posLeft: 250,
      posTop: 40,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //4
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '4',
      bold: true,
      posLeft: 330,
      posTop: 10,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //3
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '3',
      bold: true,
      posLeft: 360,
      posTop: 10,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //2
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '2',
      bold: true,
      posLeft: 390,
      posTop: 10,
      width: 50,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //1
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '1',
      bold: true,
      posLeft: 440,
      posTop: 10,
      width: 60,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //階段
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '階段',
      bold: false,
      posLeft: 540,
      posTop: 10,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //EV
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: 'EV',
      bold: false,
      posLeft: 540,
      posTop: 40,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //ATM
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: 'ATM',
      bold: false,
      posLeft: 580,
      posTop: 10,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //64
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '64',
      bold: true,
      posLeft: 650,
      posTop: 10,
      width: 40,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //7
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '7',
      bold: true,
      posLeft: 540,
      posTop: 120,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //8
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '8',
      bold: true,
      posLeft: 540,
      posTop: 150,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //9
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '9',
      bold: true,
      posLeft: 540,
      posTop: 180,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //10
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '10',
      bold: true,
      posLeft: 540,
      posTop: 210,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //11
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '11',
      bold: true,
      posLeft: 540,
      posTop: 240,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //12
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '12',
      bold: true,
      posLeft: 540,
      posTop: 270,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //63
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '63',
      bold: true,
      posLeft: 580,
      posTop: 150,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //70
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '70',
      bold: true,
      posLeft: 10,
      posTop: 80,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //69
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '69',
      bold: true,
      posLeft: 10,
      posTop: 110,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //68
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '68',
      bold: true,
      posLeft: 10,
      posTop: 140,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //45
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.red.shade300,
      label: '45',
      bold: true,
      posLeft: 10,
      posTop: 200,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //37
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '37',
      bold: true,
      posLeft: 10,
      posTop: 230,
      width: 40,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //階段
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '階段',
      bold: false,
      posLeft: 10,
      posTop: 320,
      width: 30,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //38
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '38',
      bold: true,
      posLeft: 40,
      posTop: 320,
      width: 30,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //39
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '39',
      bold: true,
      posLeft: 70,
      posTop: 320,
      width: 30,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //40
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '40',
      bold: true,
      posLeft: 100,
      posTop: 320,
      width: 40,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //52
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '52',
      bold: true,
      posLeft: 140,
      posTop: 330,
      width: 30,
      height: 40,
      onTapDown: (tapDetails) {},
    );
    //案内所
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '案内所',
      bold: false,
      posLeft: 200,
      posTop: 330,
      width: 40,
      height: 40,
      onTapDown: (tapDetails) {},
    );
    //43
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '43',
      bold: true,
      posLeft: 240,
      posTop: 320,
      width: 60,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //21
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '21',
      bold: true,
      posLeft: 300,
      posTop: 320,
      width: 60,
      height: 80,
      onTapDown: (tapDetails) {},
    );
    //16
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '16',
      bold: true,
      posLeft: 410,
      posTop: 320,
      width: 50,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //15
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '15',
      bold: true,
      posLeft: 460,
      posTop: 320,
      width: 50,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //51
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '51',
      bold: true,
      posLeft: 70,
      posTop: 110,
      width: 60,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //67
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '67',
      bold: true,
      posLeft: 70,
      posTop: 140,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //66
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '66',
      bold: true,
      posLeft: 100,
      posTop: 140,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //46
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.red.shade300,
      label: '46',
      bold: true,
      posLeft: 70,
      posTop: 200,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //34
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '34',
      bold: true,
      posLeft: 100,
      posTop: 200,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //35
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '35',
      bold: true,
      posLeft: 70,
      posTop: 230,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //36
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '36',
      bold: true,
      posLeft: 70,
      posTop: 260,
      width: 40,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //42
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '42',
      bold: true,
      posLeft: 160,
      posTop: 260,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //50
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.red.shade300,
      label: '50',
      bold: true,
      posLeft: 160,
      posTop: 110,
      width: 30,
      height: 90,
      onTapDown: (tapDetails) {},
    );
    //33
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '33',
      bold: true,
      posLeft: 160,
      posTop: 200,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //29
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '29',
      bold: true,
      posLeft: 190,
      posTop: 110,
      width: 30,
      height: 50,
      onTapDown: (tapDetails) {},
    );
    //31
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '31',
      bold: true,
      posLeft: 190,
      posTop: 160,
      width: 30,
      height: 40,
      onTapDown: (tapDetails) {},
    );
    //32
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '32',
      bold: true,
      posLeft: 190,
      posTop: 200,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //27
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '27',
      bold: true,
      posLeft: 250,
      posTop: 110,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //61
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '61',
      bold: true,
      posLeft: 250,
      posTop: 140,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //28
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '28',
      bold: true,
      posLeft: 250,
      posTop: 200,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //44
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '44',
      bold: true,
      posLeft: 250,
      posTop: 230,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //22
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '22',
      bold: true,
      posLeft: 280,
      posTop: 110,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //24
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '24',
      bold: true,
      posLeft: 280,
      posTop: 170,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //25
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '25',
      bold: true,
      posLeft: 280,
      posTop: 200,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //26
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '26',
      bold: true,
      posLeft: 280,
      posTop: 230,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //17
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '17',
      bold: true,
      posLeft: 350,
      posTop: 110,
      width: 30,
      height: 60,
      onTapDown: (tapDetails) {},
    );
    //18
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '18',
      bold: true,
      posLeft: 350,
      posTop: 170,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //19
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '19',
      bold: true,
      posLeft: 350,
      posTop: 200,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //20
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '20',
      bold: true,
      posLeft: 350,
      posTop: 230,
      width: 30,
      height: 30,
      onTapDown: (tapDetails) {},
    );
    //6
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '6',
      bold: true,
      posLeft: 400,
      posTop: 110,
      width: 50,
      height: 40,
      onTapDown: (tapDetails) {},
    );
    //23
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '23',
      bold: true,
      posLeft: 450,
      posTop: 110,
      width: 30,
      height: 40,
      onTapDown: (tapDetails) {},
    );
    //5
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '5',
      bold: true,
      posLeft: 480,
      posTop: 110,
      width: 40,
      height: 40,
      onTapDown: (tapDetails) {},
    );
    //14
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '14',
      bold: true,
      posLeft: 400,
      posTop: 150,
      width: 80,
      height: 40,
      onTapDown: (tapDetails) {},
    );
    //13
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '13',
      bold: true,
      posLeft: 480,
      posTop: 150,
      width: 40,
      height: 40,
      onTapDown: (tapDetails) {},
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
