import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/modules/authentication/controller/signup_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class TTermAndConditionCheckbox extends StatelessWidget {
  const TTermAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value,
              )),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '${TTexts.iAgreeTo} ',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                text: '${TTexts.privacyPolicy} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: isDark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: isDark ? TColors.white : TColors.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(AppScreens.privacyPolicy);
                  },
              ),
              TextSpan(
                  text: '${TTexts.and} ',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                text: '${TTexts.termsOfUse} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: isDark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: isDark ? TColors.white : TColors.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(AppScreens.termsOfUseView);
                  },
              ),
            ],
          ),
        )
      ],
    );
  }
}
