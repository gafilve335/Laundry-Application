import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/button/primary_button.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';
import '../../../controller/updateprofile/updatename_controller.dart';

class UpdateEmailView extends StatelessWidget {
  const UpdateEmailView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatenameController());
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Change Email'),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter your valid email address as you need to confirm again.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updateUserNameFormkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.email,
                    validator: (value) =>
                        TValidator.validateEmptyText('Email', value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: TTexts.email,
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    child: TPrimaryButton(
                      text: 'Save',
                      onPressed: () {
                        controller.updateEmail(controller.email.text);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
