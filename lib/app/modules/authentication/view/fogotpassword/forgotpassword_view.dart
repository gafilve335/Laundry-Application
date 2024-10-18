import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/modules/authentication/controller/forgotpassword_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class ForgotpasswordView extends StatelessWidget {
  const ForgotpasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotpasswordController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.offNamed(AppScreens.login),
              icon: const Icon(
                Icons.clear,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              TTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              TTexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            //Text field
            Form(
              key: controller.resetpasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                  labelText: TTexts.email,
                  hintText: TTexts.email,
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(TTexts.tNext),
                onPressed: () {
                  controller.sendPasswordResetEmail();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
