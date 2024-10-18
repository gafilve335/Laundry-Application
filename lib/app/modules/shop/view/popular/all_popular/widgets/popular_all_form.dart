import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/layout/grid_layout.dart';
import 'package:laundry_mobile/app/common/style/product_title_text.dart';
import 'package:laundry_mobile/app/common/style/shadows.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/popular_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class AllPopularForm extends StatelessWidget {
  const AllPopularForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LaundryPopularController());
    final firestorage = Get.put(TFirebaseStorageService());
    return Obx(() {
      return TGridLayout(
        itemCount: controller.allLaundrypopular.length,
        itemBuilder: (context, index) {
          final populartItem = controller.allLaundrypopular[index];
          return Container(
            width: 180,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                boxShadow: [TShadowStyle.verticalProductshow],
                borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                color: TColors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: TRoundedContainer(
                    height: 180,
                    width: 180,
                    padding: const EdgeInsets.all(TSizes.sm),
                    backgroundColor: TColors.light,
                    child: Stack(
                      children: [
                        Center(
                          child: TRoundedImage(
                            onPressed: () {
                              Get.toNamed(AppScreens.editPopular,
                                  arguments: populartItem);
                            },
                            image: populartItem.imageUrl,
                            imageType: ImageType.network,
                            border: Border.all(color: TColors.black),
                            fit: BoxFit.cover,
                            applyImageRadius: true,
                            width: 180,
                            height: 180,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TRoundedContainer(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TProductTitleText(
                          title: populartItem.name.toUpperCase(),
                          smallSize: true,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Get.toNamed(AppScreens.editPopular,
                                    arguments: populartItem);
                              },
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      TShadowStyle.verticalProductshow,
                                    ],
                                    color: TColors.success,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const SizedBox(
                                  width: TSizes.iconLg * 1.2,
                                  height: TSizes.iconLg * 1.2,
                                  child: Icon(
                                    Iconsax.edit,
                                    color: TColors.white,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  title: 'Delete Widget'.toUpperCase(),
                                  middleText:
                                      'Do you want to delete the Popular widget data?',
                                  textConfirm: 'Delete',
                                  textCancel: 'Cancel',
                                  backgroundColor: TColors.light,
                                  cancelTextColor: TColors.black,
                                  confirmTextColor: TColors.white,
                                  onConfirm: () async {
                                    await firestorage.deleteFileFromStorage(
                                        populartItem.imageUrl);
                                    await controller
                                        .deletePopular(populartItem.id ?? '');
                                    Get.back();
                                  },
                                  onCancel: () {},
                                  buttonColor: TColors.error,
                                );
                              },
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      TShadowStyle.verticalProductshow,
                                    ],
                                    color: TColors.error,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const SizedBox(
                                  width: TSizes.iconLg * 1.2,
                                  height: TSizes.iconLg * 1.2,
                                  child: Icon(
                                    Iconsax.trash,
                                    color: TColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
