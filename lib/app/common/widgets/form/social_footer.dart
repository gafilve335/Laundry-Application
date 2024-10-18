import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/button/social_button.dart';
import 'package:laundry_mobile/app/modules/authentication/controller/login_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';

class SocailFooter extends StatelessWidget {
  const SocailFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Container(
      padding: const EdgeInsets.only(
          top: TSizes.defaultSpace * 1.5, bottom: TSizes.defaultSpace),
      child: Column(
        children: [
          TSocialButton(
            image: TImages.googleLogo,
            background: TColors.grey,
            foreground: TColors.black,
            text: '${TTexts.tConnectWith.tr} ${TTexts.tGoogle.tr}',
            onPressed: () => controller.googleSignIn(),
          ),

          const SizedBox(height: 10),

          // TSocialButton(
          //   image: TImages.facebookLogo,
          //   foreground: TColors.white,
          //   background: TColors.facebookBgColor,
          //   text: '${TTexts.tConnectWith.tr} ${TTexts.tFacebook.tr}',
          //   onPressed: () {},
          // ),
          // const SizedBox(height: TSizes.defaultSpace * 2),
        ],
      ),
    );
  }
}
