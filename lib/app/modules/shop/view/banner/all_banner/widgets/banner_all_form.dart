import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/layout/listview_layout.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/banner_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/device/device_utility.dart';

class AllBannerForm extends StatelessWidget {
  const AllBannerForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    final firestorage = Get.put(TFirebaseStorageService());
    return Obx(() {
      return TListView(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.allBanners.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final bannersItem = controller.allBanners[index];
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Obx(() {
              if (controller.allbannerLoding.value) {
                return const TShimmerEffect(width: 160, height: 100);
              } else {
                return TRoundedContainer(
                  borderColor: TColors.accent,
                  showBorder: true,
                  backgroundColor: TColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TRoundedImage(
                        onPressed: () {
                          Get.toNamed(AppScreens.editBanner,
                              arguments: bannersItem);
                        },
                        borderRadius: 8,
                        padding: const EdgeInsets.all(8),
                        width: TDeviceUtils.getScreenWidth(context) * 0.69,
                        height: 160,
                        image: bannersItem.imageUrl,
                        imageType: ImageType.network,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TRoundedContainer(
                          backgroundColor: TColors.lightGrey,
                          borderColor: TColors.accent,
                          showBorder: true,
                          width: 60,
                          height: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.toNamed(AppScreens.editBanner,
                                        arguments: bannersItem);
                                  },
                                  icon: const Icon(
                                    Iconsax.edit,
                                    color: TColors.primary,
                                  )),
                              bannersItem.active
                                  ? const Icon(Iconsax.eye,
                                      color: TColors.primary)
                                  : const Icon(Iconsax.eye_slash),
                              IconButton(
                                onPressed: () async {
                                  await firestorage.deleteFileFromStorage(
                                      bannersItem.imageUrl);
                                  await controller
                                      .deleteBanner(bannersItem.id ?? '');
                                },
                                icon: const Icon(
                                  Iconsax.trash,
                                  color: TColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            }),
          );
        },
      );
    });
  }
}
