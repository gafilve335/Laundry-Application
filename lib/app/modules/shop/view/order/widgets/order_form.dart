import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/modules/shop/controller/order/order_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class OrderListTitle extends StatelessWidget {
  const OrderListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            children: [
              TShimmerEffect(width: 400, height: 140),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 140),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 140),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 140),
            ],
          ),
        );
      }
      if (controller.order.isEmpty) {
        return const Center(child: Text('Data Not found'));
      } else {
        return ListView.separated(
          itemCount: controller.order.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final orderItem = controller.order[index];
            return TRoundedContainer(
                radius: 5,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.dark
                    : TColors.primary,
                child: Stack(
                  children: [
                    Image.asset(TImages.cloth),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Iconsax.ship),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Processing',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .apply(
                                            color: TColors.white,
                                            fontWeightDelta: 1),
                                  ),
                                  Text(
                                    orderItem.formattedOrderDate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .apply(color: TColors.white),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.toNamed(
                                  AppScreens.orderStatement,
                                  arguments: {'index': orderItem},
                                );
                              },
                              icon: const Icon(Iconsax.arrow_right_34,
                                  size: TSizes.iconSm),
                            )
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Iconsax.tag),
                                  const SizedBox(
                                      width: TSizes.spaceBtwItems / 2),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(color: TColors.white),
                                        ),
                                        Text(orderItem.id,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .apply(color: TColors.white))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                      Icons.local_laundry_service_outlined),
                                  const SizedBox(
                                      width: TSizes.spaceBtwItems / 2),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Machine',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(color: TColors.white),
                                        ),
                                        Text(
                                          orderItem.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .apply(color: TColors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ));
          },
        );
      }
    });
  }
}
