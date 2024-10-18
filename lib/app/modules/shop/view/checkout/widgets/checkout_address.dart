import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = ProfileController.instance;
    return Column(
      children: [
        TSectionHeading(
          title: 'Details'.toUpperCase(),
          showActionButton: false,
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'User ID:',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Obx(() => Text(
                  profile.user.value.id!,
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Name of purchaser:',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Obx(() => Text(
                  profile.user.value.fullName,
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phone:',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Obx(() => Text(
                  profile.user.value.phoneNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ],
        ),
      ],
    );
  }
}
