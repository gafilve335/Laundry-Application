import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/controller/checkout/checkout_controller.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckOutController paymentController = Get.find();
    final productItem = paymentController.arguments['index'];
    final double priceAfterDiscount =
        paymentController.priceAfterDiscount.value;
    return Column(
      children: [
        TSectionHeading(
            title: 'Order Summary'.toUpperCase(), showActionButton: false),
        const SizedBox(height: 10),
        // Sub total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '\$${productItem.price}',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Coupons',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '0%',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        //discounts
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Store discounts',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${productItem.discount}%',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        //Order total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Total',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '\$$priceAfterDiscount',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
      ],
    );
  }
}
