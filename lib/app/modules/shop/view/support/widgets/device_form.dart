import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/controller/support/support_controller.dart';
import 'package:laundry_mobile/app/modules/shop/view/profile/widgets/profile_menu.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class DeviceForm extends StatelessWidget {
  const DeviceForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportController>();
    final isDark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      showBorder: true,
      backgroundColor: isDark ? TColors.darkContainer : TColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TSectionHeading(
                title: 'Device Infomation'.toUpperCase(),
                showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            Obx(() => TProfileMenu(
                showActionButton: false,
                onPressed: () {},
                title: 'Brand',
                value: controller.brand.value)),
            Obx(() => TProfileMenu(
                showActionButton: false,
                onPressed: () {},
                title: 'ID',
                value: controller.id.value)),
            Obx(() => TProfileMenu(
                showActionButton: false,
                onPressed: () {},
                title: 'Model',
                value: controller.model.value)),
            Obx(() => TProfileMenu(
                showActionButton: false,
                onPressed: () {},
                title: 'Fingerprint',
                value: controller.fingerprint.value)),
          ],
        ),
      ),
    );
  }
}
