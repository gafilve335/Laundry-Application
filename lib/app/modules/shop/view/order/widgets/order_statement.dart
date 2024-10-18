import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class OrderStatement extends StatelessWidget {
  const OrderStatement({super.key});

  @override
  Widget build(BuildContext context) {
    final ordertItem = Get.arguments['index'];
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      // ),
      backgroundColor: TColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TRoundedContainer(
                backgroundColor: TColors.lightGrey,
                height: 450,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset(TImages.washer),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ordertItem.id,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'WASHING AND IRONING',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .apply(color: TColors.primary),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Branch',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                ordertItem.branch.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Machine',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                ordertItem.name.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date & Time',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                ordertItem.orderDate.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                ordertItem.paymentMethod.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: TColors.black),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                ordertItem.price.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                '${ordertItem.discount.toString()}%',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                ordertItem.totalAmount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .apply(color: TColors.error),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.back(), child: const Text('OK')))
            ],
          ),
        ),
      ),
    );
  }
}
