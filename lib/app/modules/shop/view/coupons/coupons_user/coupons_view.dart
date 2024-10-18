import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/view/coupons/coupons_user/widgets/coupons_field.dart';
import 'package:laundry_mobile/app/modules/shop/view/coupons/coupons_user/widgets/coupons_form.dart';

class CouponsView extends StatelessWidget {
  const CouponsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('MY COUPONS'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CouponsField(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TSectionHeading(
                title: 'Redeemed Coupons'.toUpperCase(),
                showActionButton: false,
              ),
            ),
            const CouponsForm()
          ],
        ),
      ),
    );
  }
}
