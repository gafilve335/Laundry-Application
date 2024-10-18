import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/button/primary_button.dart';
import 'package:laundry_mobile/app/modules/shop/controller/updateprofile/updatename_controller.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class UpdateUserNameView extends StatelessWidget {
  const UpdateUserNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatenameController());
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Change User Name'),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter the User Name you want to change.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updateUserNameFormkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.userName,
                    validator: (value) =>
                        TValidator.validateEmptyText('UserName', value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: TTexts.username,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    child: TPrimaryButton(
                      text: 'Save',
                      onPressed: () {
                        controller.updateUserName();
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
