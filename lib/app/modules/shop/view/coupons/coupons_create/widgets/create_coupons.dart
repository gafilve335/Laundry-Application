import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/modules/shop/controller/coupons/coupons_controller.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class CreateCoupons extends StatelessWidget {
  const CreateCoupons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CouponsController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create Coupons & Muti Coupons".toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Single coupon creation
          TextFormField(
            controller: controller.couponsCreate,
            validator: (value) =>
                TValidator.validateEmptyText('Create Coupons', value),
            decoration: InputDecoration(
              labelText: "Coupons",
              prefixIcon: const Icon(Iconsax.ticket),
              suffixIcon: IconButton(
                onPressed: () {
                  controller.generateRandomCouponCode();
                },
                icon: const Icon(Iconsax.refresh),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Points input field
          TextFormField(
            controller: controller.points,
            validator: (value) => TValidator.validateEmptyText('Points', value),
            decoration: const InputDecoration(
              labelText: "Points",
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Single coupon creation button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.processCreateCoupons(),
              child: const Text('Create'),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Multiple coupons creation
          TextFormField(
            controller: controller.couponCountController,
            validator: (value) =>
                TValidator.validateEmptyText('Coupon Count', value),
            decoration: const InputDecoration(
              labelText: "Number of Coupons",
              prefixIcon: Icon(Iconsax.ticket),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.mutipoints,
            validator: (value) => TValidator.validateEmptyText('Points', value),
            decoration: const InputDecoration(
              labelText: "Points",
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          // Button to create multiple coupons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final int count =
                    int.tryParse(controller.couponCountController.text) ?? 0;
                final int points =
                    int.tryParse(controller.mutipoints.text) ?? 0;

                if (count > 0 && points > 0) {
                  controller.createMultipleCoupons(count, points);
                } else {
                  Get.snackbar(
                    'Input Error',
                    'Please enter valid numbers for count and points.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Create Multiple Coupons'),
            ),
          ),
        ],
      ),
    );
  }
}
