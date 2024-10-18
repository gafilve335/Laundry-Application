import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/order/widgets/order_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        title: Text('MY ORDERS'),
        showBackArrow: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: OrderListTitle(),
      ),
    );
  }
}
