import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:touchable/touchable.dart';

const double fmWidth = 1000;
const double fmHeight = 600;

const TextStyle fmStyle = TextStyle(
  color: kBlackColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle fmStyle2 = TextStyle(
  color: kBlackColor,
  fontSize: 12,
);

const TextStyle streetStyle = TextStyle(
  color: kBlackColor,
  fontSize: 16,
);

class FloorMap extends StatelessWidget {
  final Function(String) getShopNext;

  const FloorMap({
    required this.getShopNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fmWidth,
      height: fmHeight,
      child: CanvasTouchDetector(
        gesturesToOverride: const [
          GestureType.onTapDown,
        ],
        builder: (context) {
          return CustomPaint(
            painter: FloorMapPaint(
              context: context,
              getShopNext: getShopNext,
            ),
          );
        },
      ),
    );
  }
}

class FloorMapPaint extends CustomPainter {
  final BuildContext context;
  final Function(String) getShopNext;

  FloorMapPaint({
    required this.context,
    required this.getShopNext,
  });

  void textPaint(
    Canvas canvas, {
    required String label,
    required double posLeft,
    required double posTop,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: streetStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: fmWidth);
    double offsetX = posLeft + 4;
    double offsetY = posTop + 4;
    textPainter.paint(canvas, Offset(offsetX, offsetY));
  }

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
      ..color = kBlackColor
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
        style: bold ? fmStyle : fmStyle2,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: fmWidth);
    double offsetX = posLeft + 4;
    double offsetY = posTop + 4;
    textPainter.paint(canvas, Offset(offsetX, offsetY));
  }

  @override
  void paint(Canvas canvas, Size size) {
    TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);
    //背景
    final paintBg = Paint()..color = Colors.grey.shade100;
    touchyCanvas.drawRect(
      const Rect.fromLTWH(0, 0, fmWidth, fmHeight),
      paintBg,
    );
    //館内枠線
    final paintBuildIn = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final pathBuildIn = Path();
    pathBuildIn.moveTo(20, 20);
    pathBuildIn.lineTo(730, 20);
    pathBuildIn.lineTo(730, 490);
    pathBuildIn.lineTo(530, 490);
    pathBuildIn.lineTo(530, 510);
    pathBuildIn.lineTo(490, 510);
    pathBuildIn.lineTo(490, 550);
    pathBuildIn.lineTo(350, 550);
    pathBuildIn.lineTo(350, 580);
    pathBuildIn.lineTo(160, 580);
    pathBuildIn.lineTo(160, 490);
    pathBuildIn.lineTo(20, 490);
    pathBuildIn.close();
    touchyCanvas.drawPath(pathBuildIn, paintBuildIn);
    //館外枠線
    final paintBuildOut = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final pathBuildOut = Path();
    pathBuildOut.moveTo(730, 20);
    pathBuildOut.lineTo(880, 20);
    pathBuildOut.lineTo(980, 100);
    pathBuildOut.lineTo(980, 300);
    pathBuildOut.lineTo(730, 300);
    pathBuildOut.close();
    touchyCanvas.drawPath(pathBuildOut, paintBuildOut);
    //65
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '65',
      bold: true,
      posLeft: 20,
      posTop: 20,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('65'),
    );
    //階段
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '階段',
      bold: false,
      posLeft: 60,
      posTop: 20,
      width: 40,
      height: 60,
    );
    //47
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '47',
      bold: true,
      posLeft: 100,
      posTop: 20,
      width: 50,
      height: 80,
      onTapDown: (_) => getShopNext('47'),
    );
    //55
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '55',
      bold: true,
      posLeft: 150,
      posTop: 20,
      width: 40,
      height: 80,
      onTapDown: (_) => getShopNext('55'),
    );
    //56
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '56',
      bold: true,
      posLeft: 190,
      posTop: 20,
      width: 40,
      height: 80,
      onTapDown: (_) => getShopNext('56'),
    );
    //57
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '57',
      bold: true,
      posLeft: 270,
      posTop: 20,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('57'),
    );
    //58
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '58',
      bold: true,
      posLeft: 310,
      posTop: 20,
      width: 60,
      height: 40,
      onTapDown: (_) => getShopNext('58'),
    );
    //60
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '60',
      bold: true,
      posLeft: 270,
      posTop: 60,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('60'),
    );
    //59
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '59',
      bold: true,
      posLeft: 320,
      posTop: 60,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('59'),
    );
    //4
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '4',
      bold: true,
      posLeft: 420,
      posTop: 20,
      width: 40,
      height: 80,
      onTapDown: (_) => getShopNext('4'),
    );
    //3
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '3',
      bold: true,
      posLeft: 460,
      posTop: 20,
      width: 40,
      height: 80,
      onTapDown: (_) => getShopNext('3'),
    );
    //2
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '2',
      bold: true,
      posLeft: 500,
      posTop: 20,
      width: 60,
      height: 80,
      onTapDown: (_) => getShopNext('2'),
    );
    //1
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '1',
      bold: true,
      posLeft: 560,
      posTop: 20,
      width: 70,
      height: 80,
      onTapDown: (_) => getShopNext('1'),
    );
    //階段
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '階段',
      bold: false,
      posLeft: 670,
      posTop: 20,
      width: 60,
      height: 40,
    );
    //EV
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: 'EV',
      bold: false,
      posLeft: 670,
      posTop: 60,
      width: 60,
      height: 40,
    );
    //ATM
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: 'ATM',
      bold: false,
      posLeft: 730,
      posTop: 20,
      width: 40,
      height: 80,
    );
    //64
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '64',
      bold: true,
      posLeft: 800,
      posTop: 20,
      width: 50,
      height: 60,
      onTapDown: (_) => getShopNext('64'),
    );
    //70
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '70',
      bold: true,
      posLeft: 20,
      posTop: 120,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('70'),
    );
    //69
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '69',
      bold: true,
      posLeft: 20,
      posTop: 160,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('69'),
    );
    //68
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '68',
      bold: true,
      posLeft: 20,
      posTop: 200,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('68'),
    );
    //45
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.red.shade300,
      label: '45',
      bold: true,
      posLeft: 20,
      posTop: 280,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('45'),
    );
    //37
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '37',
      bold: true,
      posLeft: 20,
      posTop: 320,
      width: 50,
      height: 80,
      onTapDown: (_) => getShopNext('37'),
    );
    //階段
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '階段',
      bold: false,
      posLeft: 20,
      posTop: 430,
      width: 40,
      height: 60,
    );
    //38
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '38',
      bold: true,
      posLeft: 60,
      posTop: 430,
      width: 40,
      height: 60,
      onTapDown: (_) => getShopNext('38'),
    );
    //39
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '39',
      bold: true,
      posLeft: 100,
      posTop: 430,
      width: 40,
      height: 60,
      onTapDown: (_) => getShopNext('39'),
    );
    //40
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '40',
      bold: true,
      posLeft: 140,
      posTop: 430,
      width: 50,
      height: 60,
      onTapDown: (_) => getShopNext('40'),
    );
    //52
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '52',
      bold: true,
      posLeft: 190,
      posTop: 440,
      width: 30,
      height: 50,
      onTapDown: (_) => getShopNext('52'),
    );
    //案内所
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '案内所',
      bold: false,
      posLeft: 250,
      posTop: 440,
      width: 50,
      height: 50,
    );
    //搾乳室
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: '搾乳室',
      bold: false,
      posLeft: 300,
      posTop: 490,
      width: 50,
      height: 30,
    );
    //トイレ(多目的)
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: 'トイレ',
      bold: false,
      posLeft: 350,
      posTop: 490,
      width: 30,
      height: 60,
    );
    //トイレ(男子)
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: 'トイレ',
      bold: false,
      posLeft: 260,
      posTop: 550,
      width: 90,
      height: 30,
    );
    //トイレ(女子)
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.white,
      label: 'トイレ',
      bold: false,
      posLeft: 160,
      posTop: 550,
      width: 100,
      height: 30,
    );
    //43
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '43',
      bold: true,
      posLeft: 300,
      posTop: 430,
      width: 80,
      height: 60,
      onTapDown: (_) => getShopNext('43'),
    );
    //21
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '21',
      bold: true,
      posLeft: 380,
      posTop: 430,
      width: 110,
      height: 120,
      onTapDown: (_) => getShopNext('21'),
    );
    //16
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '16',
      bold: true,
      posLeft: 530,
      posTop: 430,
      width: 60,
      height: 60,
      onTapDown: (_) => getShopNext('16'),
    );
    //15
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '15',
      bold: true,
      posLeft: 590,
      posTop: 430,
      width: 60,
      height: 60,
      onTapDown: (_) => getShopNext('15'),
    );
    //7
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '7',
      bold: true,
      posLeft: 680,
      posTop: 160,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('7'),
    );
    //8
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '8',
      bold: true,
      posLeft: 680,
      posTop: 200,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('8'),
    );
    //9
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '9',
      bold: true,
      posLeft: 680,
      posTop: 240,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('9'),
    );
    //10
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '10',
      bold: true,
      posLeft: 680,
      posTop: 280,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('10'),
    );
    //11
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '11',
      bold: true,
      posLeft: 680,
      posTop: 320,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('11'),
    );
    //12
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '12',
      bold: true,
      posLeft: 680,
      posTop: 360,
      width: 50,
      height: 40,
      onTapDown: (_) => getShopNext('12'),
    );
    //63
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '63',
      bold: true,
      posLeft: 730,
      posTop: 210,
      width: 40,
      height: 60,
      onTapDown: (_) => getShopNext('63'),
    );
    //51
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.brown.shade300,
      label: '51',
      bold: true,
      posLeft: 110,
      posTop: 160,
      width: 80,
      height: 40,
      onTapDown: (_) => getShopNext('51'),
    );
    //67
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '67',
      bold: true,
      posLeft: 110,
      posTop: 200,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('67'),
    );
    //66
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.purple.shade300,
      label: '66',
      bold: true,
      posLeft: 150,
      posTop: 200,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('66'),
    );
    //46
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.red.shade300,
      label: '46',
      bold: true,
      posLeft: 110,
      posTop: 280,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('46'),
    );
    //34
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '34',
      bold: true,
      posLeft: 150,
      posTop: 280,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('34'),
    );
    //35
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '35',
      bold: true,
      posLeft: 110,
      posTop: 320,
      width: 60,
      height: 30,
      onTapDown: (_) => getShopNext('35'),
    );
    //36
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '36',
      bold: true,
      posLeft: 110,
      posTop: 350,
      width: 60,
      height: 50,
      onTapDown: (_) => getShopNext('36'),
    );
    //50
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.red.shade300,
      label: '50',
      bold: true,
      posLeft: 220,
      posTop: 160,
      width: 40,
      height: 110,
      onTapDown: (_) => getShopNext('50'),
    );
    //33
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '33',
      bold: true,
      posLeft: 220,
      posTop: 270,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('33'),
    );
    //42
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '42',
      bold: true,
      posLeft: 220,
      posTop: 360,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('42'),
    );
    //29
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '29',
      bold: true,
      posLeft: 260,
      posTop: 160,
      width: 40,
      height: 50,
      onTapDown: (_) => getShopNext('29'),
    );
    //31
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '31',
      bold: true,
      posLeft: 260,
      posTop: 210,
      width: 40,
      height: 60,
      onTapDown: (_) => getShopNext('31'),
    );
    //32
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '32',
      bold: true,
      posLeft: 260,
      posTop: 270,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('32'),
    );
    //27
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '27',
      bold: true,
      posLeft: 340,
      posTop: 160,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('27'),
    );
    //61
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '61',
      bold: true,
      posLeft: 340,
      posTop: 200,
      width: 40,
      height: 70,
      onTapDown: (_) => getShopNext('61'),
    );
    //28
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.green.shade300,
      label: '28',
      bold: true,
      posLeft: 340,
      posTop: 270,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('28'),
    );
    //44
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.orange.shade300,
      label: '44',
      bold: true,
      posLeft: 340,
      posTop: 310,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('44'),
    );
    //22
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '22',
      bold: true,
      posLeft: 380,
      posTop: 160,
      width: 40,
      height: 70,
      onTapDown: (_) => getShopNext('22'),
    );
    //24
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '24',
      bold: true,
      posLeft: 380,
      posTop: 230,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('24'),
    );
    //25
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '25',
      bold: true,
      posLeft: 380,
      posTop: 270,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('25'),
    );
    //26
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.yellow.shade300,
      label: '26',
      bold: true,
      posLeft: 380,
      posTop: 310,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('26'),
    );
    //17
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '17',
      bold: true,
      posLeft: 460,
      posTop: 160,
      width: 40,
      height: 70,
      onTapDown: (_) => getShopNext('17'),
    );
    //18
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '18',
      bold: true,
      posLeft: 460,
      posTop: 230,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('18'),
    );
    //19
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '19',
      bold: true,
      posLeft: 460,
      posTop: 270,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('19'),
    );
    //20
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '20',
      bold: true,
      posLeft: 460,
      posTop: 310,
      width: 40,
      height: 40,
      onTapDown: (_) => getShopNext('20'),
    );
    //6
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '6',
      bold: true,
      posLeft: 520,
      posTop: 160,
      width: 50,
      height: 50,
      onTapDown: (_) => getShopNext('6'),
    );
    //23
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '23',
      bold: true,
      posLeft: 570,
      posTop: 160,
      width: 30,
      height: 50,
      onTapDown: (_) => getShopNext('23'),
    );
    //5
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.blue.shade300,
      label: '5',
      bold: true,
      posLeft: 600,
      posTop: 160,
      width: 40,
      height: 50,
      onTapDown: (_) => getShopNext('5'),
    );
    //14
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '14',
      bold: true,
      posLeft: 520,
      posTop: 210,
      width: 80,
      height: 50,
      onTapDown: (_) => getShopNext('14'),
    );
    //13
    squarePaint(
      touchyCanvas,
      canvas,
      color: Colors.indigo.shade300,
      label: '13',
      bold: true,
      posLeft: 600,
      posTop: 210,
      width: 40,
      height: 50,
      onTapDown: (_) => getShopNext('13'),
    );
    //ぎっちり日曜市
    textPaint(
      canvas,
      label: 'ぎっちり日曜市',
      posLeft: 170,
      posTop: 110,
    );
    //龍馬通り
    textPaint(
      canvas,
      label: '龍馬通り',
      posLeft: 520,
      posTop: 110,
    );
    //ひろめばる
    textPaint(
      canvas,
      label: 'ひ',
      posLeft: 75,
      posTop: 130,
    );
    //はいから横丁
    textPaint(
      canvas,
      label: 'はいから横丁',
      posLeft: 110,
      posTop: 245,
    );
    //自由広場
    textPaint(
      canvas,
      label: '自由広場',
      posLeft: 200,
      posTop: 330,
    );
    //乙女小路
    textPaint(
      canvas,
      label: '乙',
      posLeft: 310,
      posTop: 180,
    );
    //いごっそう横丁
    textPaint(
      canvas,
      label: 'い',
      posLeft: 430,
      posTop: 180,
    );
    //お城下広場
    textPaint(
      canvas,
      label: 'お城下広場',
      posLeft: 540,
      posTop: 320,
    );
    //よさこい広場
    textPaint(
      canvas,
      label: 'よさこい広場',
      posLeft: 800,
      posTop: 160,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
