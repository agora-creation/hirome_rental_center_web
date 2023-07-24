import 'package:flutter/material.dart';

class AnimationBackground extends StatefulWidget {
  const AnimationBackground({Key? key}) : super(key: key);

  @override
  State<AnimationBackground> createState() => _AnimationBackgroundState();
}

class _AnimationBackgroundState extends State<AnimationBackground>
    with SingleTickerProviderStateMixin {
  late double deviceHeight;
  late double imageWidth;
  late AnimationController controller;
  late Animation<RelativeRect> rectAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceHeight = MediaQuery.of(context).size.height;
    double aspectRatio = 1.8;
    imageWidth = deviceHeight * aspectRatio;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();
    rectAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(imageWidth, 0, 0, 0),
      end: RelativeRect.fromLTRB(0, 0, imageWidth, 0),
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: rectAnimation,
      child: OverflowBox(
        maxWidth: imageWidth * 2,
        maxHeight: deviceHeight,
        child: Row(
          children: [
            Image(
              height: deviceHeight,
              fit: BoxFit.fitHeight,
              image: const AssetImage(
                'assets/images/background.png',
              ),
            ),
            Image(
              height: deviceHeight,
              fit: BoxFit.fitHeight,
              image: const AssetImage(
                'assets/images/background.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
