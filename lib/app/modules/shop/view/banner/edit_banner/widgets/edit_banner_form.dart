import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/data/models/banner_model.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/edit_banner_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class EditBannerForm extends StatelessWidget {
  const EditBannerForm({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBannerController());
    controller.init(banner);
    return TRoundedContainer(
      showBorder: true,
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Uploader & Featured Checkbox
            Column(
              children: [
                Obx(
                  () => TRoundedImage(
                    width: 400,
                    height: 200,
                    backgroundColor: TColors.primaryBackground,
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
                const SizedBox(height: TSizes.spaceBtwItems),
                TextButton(
                    onPressed: () => controller.pickImage(),
                    child: Text(
                      'Select Image',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: TColors.primary),
                    )),
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
                  onPressed: () => controller.updateBanner(banner),
                  child: const Text('Update')),
            ),
          ],
        ),
      ),
    );
  }
}
