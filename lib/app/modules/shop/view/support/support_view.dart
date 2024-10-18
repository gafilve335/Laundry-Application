import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/support/widgets/device_form.dart';
import 'package:laundry_mobile/app/modules/shop/view/support/widgets/report_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import '../../controller/support/support_controller.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(SupportController());
    return const Scaffold(
        appBar: TAppBar(
          title: Text('SUPPORT'),
          showBackArrow: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DeviceForm(),
                SizedBox(height: TSizes.spaceBtwItems),
                ReportForm()
              ],
            ),
          ),
        ));
  }
}
