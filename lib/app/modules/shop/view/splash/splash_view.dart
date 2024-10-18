import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import 'package:laundry_mobile/app/utils/device/device_utility.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? TColors.dark : TColors.light,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Hero(
                    tag: 'welcome-image-tag',
                    child: Image(
                        image: const AssetImage(TImages.appLogo),
                        width: TDeviceUtils.getScreenWidth(context) * 0.7,
                        height: TDeviceUtils.getScreenHeight() * 0.6),
                  ),
                  Column(
                    children: [
                      Text(TTexts.tWelcomeTitle,
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text(TTexts.tWelcomeSubTitle,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.toNamed(AppScreens.login),
                          child: Text(TTexts.tLogin.toUpperCase()),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(AppScreens.signup),
                          child: Text(TTexts.tSighup.toUpperCase()),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
