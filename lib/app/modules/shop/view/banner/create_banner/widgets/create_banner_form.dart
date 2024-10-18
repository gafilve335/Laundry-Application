import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/create_banner_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class CerateBannerForm extends StatelessWidget {
  const CerateBannerForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateBannerController());
    return TRoundedContainer(
      showBorder: true,
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TSizes.spaceBtwSections),

            // Image Uploader & Featured Checkbox
            Column(
              children: [
                Obx(() {
                  if (controller.loading.value) {
                    return const TShimmerEffect(width: 400, height: 200);
                  } else {
                    return GestureDetector(
                      onTap: () async {
                        await controller.pickImage();
                      },
                      child: TRoundedImage(
                        width: 400,
                        height: 200,
                        fit: BoxFit.contain,
                        backgroundColor: TColors.borderPrimary.withOpacity(0.7),
                        image: controller.selectedImage.value != null
                            ? controller.selectedImage.value!.path
                            : TImages.defaultImage,
                        imageType: controller.selectedImage.value != null
                            ? ImageType.file
                            : ImageType.asset,
                      ),
                    );
                  }
                }),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextButton(
                  onPressed: () async {
                    await controller.pickImage();
                  },
                  child: Text(
                    'Upload Image',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.primary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            Text('Make your Banner Active or InActive',
                style: Theme.of(context).textTheme.bodyMedium),
            Obx(
              () => CheckboxMenuButton(
                value: controller.isActive.value,
                onChanged: (value) =>
                    controller.isActive.value = value ?? false,
                child: Text(
                  'Active',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Dropdown Menu Screens
            Obx(
              () {
                return DropdownButton<String>(
                  value: controller.targetScreen.value,
                  onChanged: (String? newValue) =>
                      controller.targetScreen.value = newValue!,
                  items: AppScreens.allAppScreenItems
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.createBanner(),
                  child: const Text('Create')),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
