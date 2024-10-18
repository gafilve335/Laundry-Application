import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/device/device_utility.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer(
      {super.key,
      required this.text,
      this.icon = Iconsax.search_normal,
      this.showBackground = true,
      this.showBorder = true,
      this.onTap});
  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                    ? TColors.darkContainer
                    : TColors.white
                : TColors.white,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: TColors.white) : null,
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: TColors.darkGrey),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                "Search in Wash",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: TColors.darkGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
