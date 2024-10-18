import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';

class TCircularcontainer extends StatelessWidget {
  const TCircularcontainer({
    super.key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.margin,
    this.padding = 0,
    this.backgroudColor = TColors.light,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Color backgroudColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroudColor,
      ),
      child: child,
    );
  }
}
