import 'package:flutter/material.dart';

class TListView extends StatelessWidget {
  const TListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.scrollDirection,
    this.physics,
    this.controller, // เพิ่ม controller ที่นี่
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final ScrollController? controller; // เพิ่มพารามิเตอร์ controller ที่นี่

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: itemCount,
      shrinkWrap: true,
      scrollDirection: scrollDirection,
      physics: physics, // ใช้ค่า physics ที่ถูกส่งเข้ามา
      itemBuilder: itemBuilder,
    );
  }
}
