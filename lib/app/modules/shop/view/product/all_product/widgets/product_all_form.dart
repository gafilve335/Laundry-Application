import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/layout/grid_layout.dart';
import 'package:laundry_mobile/app/common/style/product_title_text.dart';
import 'package:laundry_mobile/app/common/style/shadows.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class AllProductForm extends StatelessWidget {
  const AllProductForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductCardController());
    final firestorage = Get.put(TFirebaseStorageService());

    return Obx(
      () {
        return TGridLayout(
          itemCount: controller.allproduct.length,
          itemBuilder: (context, index) {
            final productItem = controller.allproduct[index];
            return Container(
              width: 180,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  boxShadow: [TShadowStyle.verticalProductshow],
                  borderRadius:
                      BorderRadius.circular(TSizes.productImageRadius),
                  color: TColors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TRoundedContainer(
                    height: 180,
                    width: 180,
                    padding: const EdgeInsets.all(TSizes.sm),
                    backgroundColor: TColors.light,
                    child: Stack(
                      children: [
                        Center(
                          child: TRoundedImage(
                            onPressed: () {
                              Get.toNamed(AppScreens.editProduct,
                                  arguments: productItem);
                            },
                            image: productItem.imageUrl,
                            imageType: ImageType.network,
                            border:
                                Border.all(width: 1.5, color: TColors.primary),
                            applyImageRadius: true,
                            width: 180,
                            height: 180,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
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
                          Row(
                            children: [
                              Expanded(
                                child: TProductTitleText(
                                  title: productItem.name.toUpperCase(),
                                  smallSize: true,
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: productItem.active
                                        ? TColors.black
                                        : TColors.warning,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        productItem.active
                                            ? "Active".toUpperCase()
                                            : "Inactive".toUpperCase(),
                                        style: const TextStyle(
                                            color: TColors.white),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Get.toNamed(AppScreens.editProduct,
                                      arguments: productItem);
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
                                        'Do you want to delete the Washer widget data?',
                                    textConfirm: 'Delete',
                                    textCancel: 'Cancel',
                                    backgroundColor: TColors.light,
                                    cancelTextColor: TColors.black,
                                    confirmTextColor: TColors.white,
                                    onConfirm: () async {
                                      await firestorage.deleteFileFromStorage(
                                          productItem.imageUrl);
                                      await controller
                                          .deleteProduct(productItem.id ?? '');
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
      },
    );
  }
}
