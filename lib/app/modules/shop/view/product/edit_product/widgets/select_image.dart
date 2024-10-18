import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/edit_product_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class SelectImage extends StatelessWidget {
  const SelectImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());
    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Washer Image'.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),
          TRoundedContainer(
            height: 300,
            backgroundColor: TColors.lightGrey,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () async {
                        await controller.pickImage();
                      },
                      child: TRoundedImage(
                        width: 300,
                        height: 200,
                        fit: BoxFit.contain,
                        backgroundColor: TColors.borderPrimary.withOpacity(0.7),
                        image: controller.selectedImage.value != null
                            ? controller.selectedImage.value!.path
                            : (controller.imageURL.value.isNotEmpty
                                ? controller.imageURL.value
                                : TImages.defaultImage),
                        imageType: controller.selectedImage.value != null
                            ? ImageType.file
                            : (controller.imageURL.value.isNotEmpty
                                ? ImageType.network
                                : ImageType.asset),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: 150,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () => controller.pickImage(),
                          child: const Text(
                            'Select Image',
                            style: TextStyle(fontSize: 15),
                          ))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
