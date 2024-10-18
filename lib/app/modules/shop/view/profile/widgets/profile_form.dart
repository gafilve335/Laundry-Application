import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/common/widgets/image/image_circular.dart';
import 'package:laundry_mobile/app/modules/shop/view/profile/widgets/profile_menu.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.instance;
    final isDark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Obx(() {
                final networkImage = controller.user.value.profilePicture;
                final image =
                    networkImage.isNotEmpty ? networkImage : TImages.user;
                return controller.imageUploading.value
                    ? const TShimmerEffect(width: 80, height: 80, radius: 80)
                    : TCircularImage(
                        image: image,
                        width: 100,
                        height: 100,
                        isNetworkImage: networkImage.isNotEmpty,
                      );
              }),
              TextButton(
                onPressed: () => controller.uploadUserProfilePicture(),
                child: Text(
                  'Chang Profile Picture',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Divider(color: isDark ? TColors.white : TColors.grey),
        const SizedBox(height: TSizes.spaceBtwItems),
        const TSectionHeading(
            title: 'Profile Infomation', showActionButton: false),
        const SizedBox(height: TSizes.spaceBtwItems),
        TProfileMenu(
          title: 'Name',
          value: controller.user.value.fullName,
          onPressed: () => Get.toNamed(AppScreens.updateName),
        ),
        TProfileMenu(
          title: 'Username',
          value: controller.user.value.userName,
          onPressed: () => Get.toNamed(AppScreens.updateUserName),
        ),

        // Divider
        const SizedBox(height: TSizes.spaceBtwItems),
        Divider(color: isDark ? TColors.white : TColors.grey),
        const SizedBox(height: TSizes.spaceBtwItems),

        // Heading Personal Info
        const TSectionHeading(
            title: 'Personal Infomation', showActionButton: false),
        const SizedBox(height: TSizes.spaceBtwItems),

        TProfileMenu(
          title: 'User ID',
          value: controller.user.value.id!,
          icon: Iconsax.copy,
          onPressed: () {
            FlutterClipboard.copy(controller.user.value.id!);
          },
        ),
        TProfileMenu(
          title: 'E-mail',
          value: controller.user.value.email,
          icon: Icons.error,
          onPressed: () {
            Get.showSnackbar(
              const GetSnackBar(
                backgroundColor: TColors.error,
                icon: Icon(Icons.error, color: TColors.white),
                message: 'You cannot change your login email address.',
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        TProfileMenu(
            title: 'Phone Number',
            value: controller.user.value.phoneNumber,
            onPressed: () => Get.toNamed(AppScreens.updatePhone)),
        TProfileMenu(
          title: 'Created',
          value: controller.user.value.createdAt.toString(),
          icon: Icons.error,
          onPressed: () {
            Get.showSnackbar(
              const GetSnackBar(
                backgroundColor: TColors.error,
                icon: Icon(Icons.error, color: TColors.white),
                message: 'The date the account was created cannot be changed.',
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        Divider(color: isDark ? TColors.white : TColors.grey),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: TextButton(
              onPressed: () => controller.deleteAccountWarningPopup(),
              child: Text(
                'Close Account'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: TColors.error),
              )),
        )
      ],
    );
  }
}
