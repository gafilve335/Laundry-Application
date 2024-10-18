import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/layout/grid_layout.dart';
import 'package:laundry_mobile/app/common/style/product_title_text.dart';
import 'package:laundry_mobile/app/common/style/shadows.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';
import 'package:laundry_mobile/app/utils/helpers/pricing_calculator.dart';
import 'package:laundry_mobile/app/data/services/mqtt_service.dart'
    as mqtt_service;

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProductCardController.instance;
    final profile = ProfileController.instance;

    return Obx(() {
      if (controller.isLoading.value) {
        return TVerticalProductShimmer(itemCount: controller.product.length);
      } else {
        // ใช้ MediaQuery เพื่อดึงขนาดของหน้าจอ
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = screenWidth * 0.41; // ขนาดที่สัมพันธ์กับหน้าจอ

        return TGridLayout(
          itemCount: controller.product.length,
          itemBuilder: (context, index) {
            final productItem = controller.product[index];
            final priceAfterDiscount =
                TPricingCalculator.calculatePriceAfterDiscount(
                    productItem.price, productItem.discount);

            return GestureDetector(
              onTap: () {},
              child: Container(
                width: itemWidth,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  boxShadow: [TShadowStyle.verticalProductshow],
                  borderRadius:
                      BorderRadius.circular(TSizes.productImageRadius),
                  color: TColors.white,
                ),
                child: Column(
                  children: [
                    TRoundedContainer(
                      height: itemWidth,
                      width: itemWidth,
                      padding: const EdgeInsets.all(TSizes.sm),
                      backgroundColor: TColors.light,
                      child: Stack(
                        children: [
                          Center(
                            child: Obx(() => TRoundedImage(
                                  imageType: ImageType.network,
                                  image: productItem.imageUrl,
                                  applyImageRadius: true,
                                  width: itemWidth,
                                  height: itemWidth,
                                  border: Border.all(
                                    width: 1.5,
                                    color: THelperFunctions.getPayloadColor(
                                      controller.payloads[productItem.topic] ??
                                          mqtt_service
                                              .ConnectionState.initialized,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                )),
                          ),
                          _buildDiscountTag(context, controller, productItem),
                          _buildEditButton(context, profile, productItem),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Padding(
                      padding: const EdgeInsets.only(left: TSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TProductTitleText(
                              title: productItem.name, smallSize: true),
                          _buildWasherStatus(context, controller, productItem),
                          const SizedBox(height: TSizes.spaceBtwItems / 2),
                          _buildPriceAndActionButton(
                              context, priceAfterDiscount, productItem),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }

  Widget _buildDiscountTag(BuildContext context,
      ProductCardController controller, ProductCardModel productItem) {
    return Positioned(
      top: 7,
      left: 8,
      child: controller.checkIfProductIsDiscounted(productItem)
          ? TRoundedContainer(
              radius: TSizes.sm,
              backgroundColor: TColors.secondary,
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm, vertical: TSizes.xs),
              child: Text(
                '${productItem.discount.toStringAsFixed(0)}%',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .apply(color: TColors.black),
              ),
            )
          : Container(),
    );
  }

  Widget _buildEditButton(BuildContext context, ProfileController profile,
      ProductCardModel productItem) {
    return Positioned(
      top: 10,
      right: 10,
      child: TRoundedContainer(
        backgroundColor: TColors.primary,
        height: 40,
        child: Visibility(
          visible: profile.user.value.role == AppRole.admin,
          child: IconButton(
            icon: const Icon(Iconsax.edit),
            color: TColors.white,
            onPressed: () => Get.toNamed(
              AppScreens.editProduct,
              arguments: productItem,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWasherStatus(BuildContext context,
      ProductCardController controller, ProductCardModel productItem) {
    return Obx(() {
      if (controller.mqttStatusLoading.value) {
        return const Column(
          children: [
            SizedBox(height: 3),
            TShimmerEffect(width: 120, height: 10),
          ],
        );
      } else {
        return Row(
          children: [
            Text(
              THelperFunctions.getPayloadText(
                controller.payloads[productItem.topic] ??
                    mqtt_service.ConnectionState.initialized,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(width: TSizes.xs),
            Icon(
              Icons.online_prediction_outlined,
              color: THelperFunctions.getPayloadColor(
                controller.payloads[productItem.topic] ??
                    mqtt_service.ConnectionState.initialized,
              ),
              size: TSizes.iconSm,
            ),
          ],
        );
      }
    });
  }

  Widget _buildPriceAndActionButton(BuildContext context,
      double priceAfterDiscount, ProductCardModel productItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '\$${priceAfterDiscount.toStringAsFixed(0)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(
              productItem.targetScreen,
              arguments: {'index': productItem},
              preventDuplicates: true,
            );
          },
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              boxShadow: [TShadowStyle.verticalProductshow],
              color: TColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: TSizes.iconLg * 1.2,
                  height: TSizes.iconLg * 1.2,
                  child: Icon(Icons.qr_code, color: TColors.white),
                ),
                Text(
                  'Scan',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: TColors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
