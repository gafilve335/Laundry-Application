import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/create_product_controller.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/create_product/widgets/seletc_image.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/list.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class CreateProductForm extends StatelessWidget {
  const CreateProductForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProductController());
    return Form(
      key: controller.createproduct,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CreateSeleceProductImage(),
          const SizedBox(height: TSizes.defaultSpace),
          TRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(16),
            backgroundColor: TColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Washer Infomation'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.defaultSpace),
                // Laundry Title Input Field
                TextFormField(
                  controller: controller.machineName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Machine Name', value),
                  decoration: const InputDecoration(labelText: 'Machine Name'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Laundry City Input Field
                TextFormField(
                  controller: controller.branch,
                  validator: (value) =>
                      TValidator.validateEmptyText('Branch Name', value),
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    suffixIcon: DropdownButton<String>(
                      value:
                          null, // ตั้งค่าเริ่มต้นให้เป็น null เพื่อให้ไม่มีชื่อซ้ำ
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: const SizedBox.shrink(), // เอาเส้นใต้ออก
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectedProvince.value = newValue;
                          controller.branch.text =
                              newValue; // อัปเดตค่าใน TextFormField
                        }
                      },
                      items: thaiProvinces
                          .map<DropdownMenuItem<String>>((String province) {
                        return DropdownMenuItem<String>(
                          value: province,
                          child: Text(province),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                // DestibationLat Input Field
                TextFormField(
                  controller: controller.price,
                  validator: (value) =>
                      TValidator.validateEmptyText('Price', value),
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.discount,
                  validator: (value) =>
                      TValidator.validateEmptyText('Discount', value),
                  decoration: const InputDecoration(labelText: 'Discount'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TRoundedContainer(
            backgroundColor: TColors.white,
            showBorder: true,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MQTT Server Details'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.defaultSpace),
                TextFormField(
                  controller: controller.clientId,
                  validator: (value) =>
                      TValidator.validateEmptyText('ClientId', value),
                  decoration: InputDecoration(
                      labelText: 'ClientId',
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.generateRandomClientId();
                          },
                          icon: const Icon(Iconsax.refresh))),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                //  Map Launcher Name Input Field
                TextFormField(
                  controller: controller.serverUrl,
                  validator: (value) =>
                      TValidator.validateEmptyText('ServerUrl', value),
                  decoration: const InputDecoration(labelText: 'ServerUrl'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // DestibationLat Input Field
                TextFormField(
                  controller: controller.topic,
                  validator: (value) =>
                      TValidator.validateEmptyText('Topic', value),
                  decoration: const InputDecoration(labelText: 'Topic'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Text(
                      'Quality of Service:',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 15),
                    Obx(
                      () => DropdownButton<CustomMqttQos>(
                        value: controller.mqttQos.value,
                        onChanged: (CustomMqttQos? newValue) {
                          if (newValue != null) {
                            controller.mqttQos.value = newValue;
                          }
                        },
                        items: CustomMqttQos.values.map((CustomMqttQos qos) {
                          return DropdownMenuItem<CustomMqttQos>(
                            value: qos,
                            child: Text(qos.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TRoundedContainer(
            backgroundColor: TColors.white,
            padding: const EdgeInsets.all(16),
            showBorder: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hardware".toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.defaultSpace),
                TextFormField(
                  controller: controller.ldr,
                  validator: (value) =>
                      TValidator.validateEmptyText('ldr', value),
                  decoration:
                      const InputDecoration(labelText: 'Light Threshold'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'Washer Mode',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const Text(':'),
                    const SizedBox(width: 8),
                    Obx(() {
                      return DropdownButton<WasherMode>(
                        value: controller.wMode.value,
                        onChanged: (WasherMode? newValue) {
                          controller.wMode.value = newValue;
                        },
                        items:
                            WasherMode.values.map<DropdownMenuItem<WasherMode>>(
                          (WasherMode value) {
                            return DropdownMenuItem<WasherMode>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          },
                        ).toList(),
                      );
                    }),
                  ],
                ),
                Row(
                  children: [
                    Text('Make your Buzzer Active or InActive :',
                        style: Theme.of(context).textTheme.labelSmall),
                    Obx(
                      () => CheckboxMenuButton(
                        value: controller.isbuzzer.value,
                        onChanged: (value) =>
                            controller.isbuzzer.value = value ?? false,
                        child: Text(
                          'Active',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TRoundedContainer(
            backgroundColor: TColors.white,
            padding: const EdgeInsets.all(16),
            showBorder: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Redirect & Active'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.defaultSpace),
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
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ));
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
                        child: Text(
                          'Active',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.createProduct(),
                      child: const Text('Create')),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
