import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/modules/shop/view/checkout/widgets/checkout_address.dart';
import 'package:laundry_mobile/app/modules/shop/view/checkout/widgets/checkout_button.dart';
import 'package:laundry_mobile/app/modules/shop/view/checkout/widgets/checkout_section.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';
import '../../controller/checkout/checkout_controller.dart';

class CheckOutView extends StatelessWidget {
  const CheckOutView({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(CheckOutController());
    final productItem = controller.arguments['index'];
    final double priceAfterDiscount = controller.priceAfterDiscount.value;

    return Scaffold(
      appBar: const TAppBar(
        title: Text('CHECKOUT'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TRoundedContainer(
                radius: 5,
                child: Row(
                  children: [
                    TRoundedContainer(
                      height: 140,
                      padding: const EdgeInsets.all(TSizes.sm),
                      backgroundColor: isDark ? TColors.dark : TColors.white,
                      child: Stack(
                        children: [
                          TRoundedImage(
                              width: 120,
                              height: 120,
                              imageType: ImageType.network,
                              image: '${productItem.imageUrl}',
                              applyImageRadius: true),
                          Positioned(
                            child: controller
                                    .checkIfProductIsDiscounted(productItem)
                                ? TRoundedContainer(
                                    backgroundColor:
                                        TColors.secondary.withOpacity(0.8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: TSizes.sm,
                                        vertical: TSizes.xs),
                                    child: Text(
                                      '${productItem.discount.toStringAsFixed(0)}%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(color: TColors.black),
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    //Detail
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: TSizes.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${productItem.name}'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .apply(color: TColors.primary)
                                    .copyWith(letterSpacing: 5.0),
                              ),
                              Text(
                                'Branch: ${productItem.branch}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(letterSpacing: 2.0),
                              ),
                              Text(
                                'Price: \$$priceAfterDiscount',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(letterSpacing: 2.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              //const SizedBox(height: TSizes.spaceBtwSections),
              //const CouponWidget(),
              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                radius: 5,
                padding: const EdgeInsets.all(TSizes.md),
                //showBorder: true,
                backgroundColor: isDark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    SizedBox(height: TSizes.spaceBtwItems),

                    // Pricing
                    TBillingPaymentSection(),
                    SizedBox(height: TSizes.spaceBtwSections),

                    //Divider
                    Divider(color: TColors.black),
                    SizedBox(height: TSizes.spaceBtwItems),
                    TBillingAddressSection(),
                    SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const CheckOutButton()
            ],
          ),
        ),
      ),
    );
  }
}
