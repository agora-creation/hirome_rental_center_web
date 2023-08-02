import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class CustomImage extends StatelessWidget {
  final String src;

  const CustomImage(this.src, {super.key});

  @override
  Widget build(BuildContext context) {
    if (src != '') {
      return Image.network(
        src,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loading) {
          if (loading == null) return child;
          return Image.asset(
            kDefaultImageUrl,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        kDefaultImageUrl,
        fit: BoxFit.cover,
      );
    }
  }
}
