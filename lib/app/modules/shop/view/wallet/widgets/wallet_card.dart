import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = ProfileController.instance;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TRoundedContainer(
              radius: 5,
              height: 150,
              backgroundColor: TColors.primary,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const SizedBox(width: 25),
                          Text(
                            'AVAILABLE BALANCE',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: TColors.white),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 25),
                          Text('\$',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .apply(color: TColors.white)),
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
                  Image.asset(TImages.cloth)
                ],
              )),
        ],
      ),
    );
  }
}
