import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/common/widgets/container/circular_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/banner_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class TBanner extends StatelessWidget {
  const TBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = BannerController.instance;
    final profile = ProfileController.instance;
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const TShimmerEffect(width: double.infinity, height: 190);
        }

        if (controller.banners.isEmpty) {
          return const Center(child: Text('No Data Found'));
        } else {
          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 1,
                  onPageChanged: (index, _) =>
                      controller.updatePageIndicator(index),
                ),
                items: controller.banners.map((banner) {
                  return Stack(
                    children: [
                      TRoundedImage(
                        image: banner.imageUrl,
                        imageType: ImageType.network,
                        onPressed: () => Get.toNamed(banner.targetScreen),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: TRoundedContainer(
                          height: 40,
                          backgroundColor: TColors.primary,
                          child: Visibility(
                            visible: profile.user.value.role == AppRole.admin,
                            child: IconButton(
                              icon: const Icon(Iconsax.edit),
                              color: TColors.white,
                              onPressed: () => Get.toNamed(
                                AppScreens.editBanner,
                                arguments: banner,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < controller.banners.length; i++)
                      TCircularcontainer(
                        width: 20,
                        height: 4,
                        margin: const EdgeInsets.only(right: 10),
                        backgroudColor:
                            controller.carousalCurrentIndex.value == i
                                ? TColors.primary
                                : TColors.grey,
                      ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
