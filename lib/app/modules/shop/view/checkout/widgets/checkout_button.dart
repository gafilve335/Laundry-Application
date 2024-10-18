import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/modules/shop/controller/checkout/checkout_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';

class CheckOutButton extends StatelessWidget {
  const CheckOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckOutController());
    final productItem = controller.arguments['index'];
    final double priceAfterDiscount = controller.priceAfterDiscount.value;
    final profile = ProfileController.instance;
    return TRoundedContainer(
      padding: const EdgeInsets.all(16),
      radius: 5,
      height: 100,
      backgroundColor: TColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'TOTAL',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '\$$priceAfterDiscount',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(color: TColors.error),
                  )
                ],
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                    onPressed: () async {
                      if (profile.user.value.points > priceAfterDiscount) {
                        Get.offNamed('/qrcode',
                            arguments: {'index': productItem},
                            preventDuplicates: true);
                        // TLoggerHelper.debug(
                        //     '${profile.user.value.points}');
                      } else {
                        HelperShackBar.errorSnackBar(
                            title: 'Failed',
                            message: 'Not enough points remaining.');
                      }
                    },
                    child: Text('Checkout '.toUpperCase())),
              )
            ],
          ),
        ],
      ),
    );
  }
}
