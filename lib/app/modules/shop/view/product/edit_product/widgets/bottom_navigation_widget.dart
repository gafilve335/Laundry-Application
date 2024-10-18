import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/edit_product_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductBottomNavigationButtons extends StatelessWidget {
  const ProductBottomNavigationButtons({
    super.key,
    required this.product,
  });

  final ProductCardModel product;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Discard button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: TColors.error,
              foregroundColor: TColors.white,
            ),
            onPressed: () {
              _showConfirmationDialog();
            },
            child: const Text('Delete'),
          ),

          const SizedBox(width: TSizes.spaceBtwItems / 2),

          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () =>
                  EditProductController.instance.updateProduct(product),
              child: const Text('Update'),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show confirmation dialog
  void _showConfirmationDialog() {
    final firestorage = Get.put(TFirebaseStorageService());
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: 'Delete Widgets',
        titleStyle: const TextStyle(color: TColors.black),
        backgroundColor: TColors.white,
        middleTextStyle: const TextStyle(color: TColors.black),
        middleText: 'Do you want to delete the Washer widget data?',
        confirm: ElevatedButton(
          onPressed: () async {
            await firestorage.deleteFileFromStorage(product.imageUrl);
            await ProductCardController.instance
                .deleteProduct(product.id ?? '');
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
            child: Text(
              'Delete',
            ),
          ),
        ),
        cancel: OutlinedButton(
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: TColors.black),
            )));
  }
}
