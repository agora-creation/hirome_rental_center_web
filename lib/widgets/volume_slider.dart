import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class VolumeSlider extends StatelessWidget {
  final double value;
  final Function(double)? onChanged;

  const VolumeSlider({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      onChanged: onChanged,
      min: 0.0,
      max: 1.0,
      label: '$value',
      activeColor: kBlueColor,
      inactiveColor: kGreyColor,
    );
  }
}
