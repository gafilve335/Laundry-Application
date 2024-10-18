import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/create_popular_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class CreatePopularForm extends StatelessWidget {
  const CreatePopularForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatePopularController());
    return TRoundedContainer(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.createPopularFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => GestureDetector(
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
                )),

            TextButton(
                onPressed: () => controller.pickImage(),
                child: Text(
                  'Select Image',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: TColors.primary),
                )),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            // Laundry Title Input Field
            TextFormField(
              controller: controller.laundryName,
              validator: (value) =>
                  TValidator.validateEmptyText('Laundry Name', value),
              decoration: const InputDecoration(labelText: 'Laundry Name'),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Laundry City Input Field
            TextFormField(
              controller: controller.city,
              validator: (value) =>
                  TValidator.validateEmptyText('City Name', value),
              decoration: const InputDecoration(labelText: 'City Name'),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            //  Map Launcher Name Input Field
            TextFormField(
              controller: controller.mapLauncher,
              validator: (value) =>
                  TValidator.validateEmptyText('Map Launcher Name', value),
              decoration: const InputDecoration(labelText: 'Map Launcher Name'),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // DestibationLat Input Field
            TextFormField(
              controller: controller.destibationLat,
              validator: (value) =>
                  TValidator.validateEmptyText('DestibationLat', value),
              decoration: const InputDecoration(labelText: 'DestibationLat'),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // DestibationLat Input Field
            TextFormField(
              controller: controller.destibationLon,
              validator: (value) =>
                  TValidator.validateEmptyText('DestibationLon', value),
              decoration: const InputDecoration(labelText: 'DestibationLon'),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              controller: controller.rating,
              validator: (value) =>
                  TValidator.validateEmptyText('DestibationLon', value),
              decoration: const InputDecoration(labelText: 'Rating'),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Row(
              children: [
                Text('Redirect Screen :',
                    style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(width: 15),
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
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Row(
              children: [
                Text('Make your Popular Active or InActive :',
                    style: Theme.of(context).textTheme.labelSmall),
                Obx(
                  () => CheckboxMenuButton(
                    value: controller.isActive.value,
                    onChanged: (value) =>
                        controller.isActive.value = value ?? false,
                    child: const Text('Active'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.createPopular(),
                  child: const Text('Create')),
            ),
          ],
        ),
      ),
    );
  }
}
