import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/coupons/coupons_create/widgets/create_coupons.dart';

class CouponsCreateView extends StatelessWidget {
  const CouponsCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          "Create Coupons".toUpperCase(),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [CreateCoupons()],
        ),
      ),
    );
  }
}
