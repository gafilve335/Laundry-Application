import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/common/widgets/image/image_circular.dart';
import 'package:laundry_mobile/app/modules/shop/view/account/widgets/account_menu_title.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    final profile = ProfileController.instance;
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        centerTitle: true,
        title: Text(
          'A C C O U N T',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TRoundedContainer(
              radius: 0,
              child: ListTile(
                leading: Obx(() {
                  final networkImage = profile.user.value.profilePicture;
                  final image =
                      networkImage.isNotEmpty ? networkImage : TImages.user;
                  return profile.imageUploading.value
                      ? const TShimmerEffect(width: 80, height: 80, radius: 80)
                      : TCircularImage(
                          image: image,
                          width: 56,
                          height: 56,
                          isNetworkImage: networkImage.isNotEmpty,
                        );
                }),
                title: Obx(() {
                  if (profile.profileLoading.value) {
                    return const TShimmerEffect(width: 80, height: 15);
                  } else {
                    return Text(
                      profile.user.value.fullName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  }
                }),
                subtitle: Obx(() {
                  if (profile.profileLoading.value) {
                    return const TShimmerEffect(width: 80, height: 15);
                  } else {
                    return Text(
                      profile.user.value.email,
                      style: Theme.of(context).textTheme.labelMedium,
                    );
                  }
                }),
                trailing: IconButton(
                    onPressed: () => Get.toNamed(AppScreens.profile),
                    icon: const Icon(
                      Iconsax.edit,
                      color: TColors.primary,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  TRoundedContainer(
                    backgroundColor:
                        isDark ? TColors.darkContainer : TColors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: TSectionHeading(
                              title: 'Account Setting'.toUpperCase(),
                              showActionButton: false),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        TSettingsMenuTile(
                          icon: Iconsax.wallet,
                          title: 'My Wallet',
                          subtitle: 'Manage payment information',
                          onTap: () => Get.toNamed(AppScreens.wallet),
                        ),
                        TSettingsMenuTile(
                          icon: Iconsax.discount_shape,
                          title: 'My Coupons',
                          subtitle: 'Let off all the discounted coupons',
                          onTap: () => Get.toNamed(AppScreens.coupons),
                        ),
                        TSettingsMenuTile(
                          icon: Iconsax.box,
                          title: 'My Order',
                          subtitle: 'History of use of the washing machine',
                          onTap: () => Get.toNamed(AppScreens.order),
                        ),
                        TSettingsMenuTile(
                          icon: Iconsax.support,
                          title: 'Support',
                          subtitle:
                              'Report a problem and contact the developer.',
                          onTap: () => Get.toNamed(AppScreens.support),
                        ),
                        Obx(
                          () => TSettingsMenuTile(
                            icon: Iconsax.data,
                            title: 'Management',
                            visible: profile.user.value.role == AppRole.admin,
                            subtitle: 'Manage data',
                            onTap: () => Get.toNamed(AppScreens.loadData),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TRoundedContainer(
                    backgroundColor:
                        isDark ? TColors.darkContainer : TColors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: TSectionHeading(
                              title: 'Additional'.toUpperCase(),
                              showActionButton: false),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        TSettingsMenuTile(
                          icon: Iconsax.security,
                          title: 'Terms & Conditions',
                          subtitle:
                              'Privacy policies and terms are vital for appication ',
                          onTap: () => Get.toNamed(AppScreens.termsOfUseView),
                        ),
                        TSettingsMenuTile(
                          icon: Iconsax.logout,
                          title: 'Logout',
                          subtitle: 'Log out of your system ',
                          onTap: () => profile.logoutAccountWarningPopup(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
