import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/user/user_details/widgets/order_details_form.dart';
import 'package:laundry_mobile/app/modules/shop/view/user/user_details/widgets/user_details_form.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('User Details'.toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserDetailsForm(user: user),
            const Divider(indent: 40, endIndent: 40),
            OrderSingleForm(user: user),
          ],
        ),
      ),
    );
  }
}
