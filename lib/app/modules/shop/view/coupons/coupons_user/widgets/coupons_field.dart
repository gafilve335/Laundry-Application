import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/modules/shop/controller/coupons/coupons_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/device/device_utility.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class CouponsField extends StatelessWidget {
  const CouponsField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CouponsController.instance;
    final profile = ProfileController.instance;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            children: [
              TRoundedContainer(
                width: TDeviceUtils.getScreenWidth(context) * 1,
                height: MediaQuery.of(context).size.height * 0.15,
                backgroundColor: TColors.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        Text(
                          'Wallet',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: TColors.white),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        Text(
                          '\$',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: TColors.white),
                        ),
                        const SizedBox(width: 5),
                        Obx(() => Text('${profile.user.value.points}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(color: TColors.white))),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Image.asset(TImages.cloth)
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TextFormField(
            controller: controller.coupons,
            validator: (value) =>
                TValidator.validateEmptyText('Coupons', value),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Iconsax.ticket,
                color: TColors.primary,
              ),
              labelText: 'Coupons',
              fillColor: TColors.white,
              filled: true,
              suffixIcon: GestureDetector(
                onTap: () => controller.processCoupons(controller.coupons.text),
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(
                      Iconsax.arrow_right,
                      color: TColors.primary,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
