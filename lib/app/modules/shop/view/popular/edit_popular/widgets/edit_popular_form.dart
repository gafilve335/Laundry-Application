import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/data/models/laundry_popular_model.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/edit_popular_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class EditPopularForm extends StatelessWidget {
  const EditPopularForm({
    super.key,
    required this.popular,
  });

  final LaundryPopularModel popular;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPopularController());
    controller.init(popular);
    return TRoundedContainer(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.editPopularFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => GestureDetector(
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
            const SizedBox(height: 10),
            OutlinedButton(
                onPressed: () => controller.pickImage(),
                child: const Text('Select Image')),
            // Laundry Title Input Field
            const SizedBox(height: TSizes.spaceBtwItems),
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
                  onPressed: () {
                    controller.updatePopular(popular);
                  },
                  child: const Text('Update')),
            ),
          ],
        ),
      ),
    );
  }
}
