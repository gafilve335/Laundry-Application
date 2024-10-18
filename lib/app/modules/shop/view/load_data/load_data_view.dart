import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/view/account/widgets/account_menu_title.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';

class LoadDataView extends StatelessWidget {
  const LoadDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Management'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TRoundedContainer(
                showBorder: true,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: TSectionHeading(
                        title: "USER SETTING",
                        showActionButton: false,
                      ),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.user,
                      title: 'USER',
                      subtitle: 'Show User Information',
                      onTap: () => Get.toNamed(AppScreens.customers),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.ticket,
                      title: "COUPONS",
                      subtitle: "Create Coupons",
                      onTap: () => Get.toNamed(AppScreens.createCoupons),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.support,
                      title: "Support",
                      subtitle: "Support Infomation",
                      onTap: () => Get.toNamed(AppScreens.supportDetail),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TRoundedContainer(
                showBorder: true,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: TSectionHeading(
                        title: "BANNER SETTING",
                        showActionButton: false,
                      ),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.picture_frame,
                      title: 'BANNER ALL',
                      subtitle: 'Show Banner Information',
                      onTap: () => Get.toNamed(AppScreens.allBanner),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.picture_frame,
                      title: 'CREATE BANNER',
                      subtitle: 'Create Banner Information',
                      onTap: () => Get.toNamed(AppScreens.createBanner),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TRoundedContainer(
                showBorder: true,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: TSectionHeading(
                        title: "POPULAR SETTING",
                        showActionButton: false,
                      ),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.map,
                      title: 'POPULAR ALL',
                      subtitle: 'Show Popular Information',
                      onTap: () => Get.toNamed(AppScreens.allPopular),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.map,
                      title: 'CREATE POPULAR',
                      subtitle: 'Create Popular Information',
                      onTap: () => Get.toNamed(AppScreens.createPopular),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TRoundedContainer(
                showBorder: true,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: TSectionHeading(
                        title: "WASHER SETTING",
                        showActionButton: false,
                      ),
                    ),
                    TSettingsMenuTile(
                      icon: Icons.local_laundry_service_outlined,
                      title: 'WASHER ALL',
                      subtitle: 'Show Product Information',
                      onTap: () => Get.toNamed(AppScreens.allProduct),
                    ),
                    TSettingsMenuTile(
                      icon: Icons.local_laundry_service_outlined,
                      title: 'CREATE WASHER',
                      subtitle: 'Create Product Information',
                      onTap: () => Get.toNamed(AppScreens.createProduct),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
