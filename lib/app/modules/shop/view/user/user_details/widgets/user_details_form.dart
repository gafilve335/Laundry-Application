import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/data/models/user_model.dart';
import 'package:laundry_mobile/app/modules/shop/controller/user/user_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';

class UserDetailsForm extends StatelessWidget {
  const UserDetailsForm({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    controller.init(user);

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            showBorder: false,
            backgroundColor: TColors.light,
            child: Form(
              key: controller.updateAdminUserProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TSectionHeading(
                    title: 'Edit User Information'.toUpperCase(),
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TextFormField(
                    controller: controller.userName,
                    decoration: const InputDecoration(labelText: 'User Name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'User Name cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.phoneNumber,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Phone number cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.points,
                    decoration: const InputDecoration(labelText: 'Points'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Points cannot be empty'
                        : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: controller.addPoints,
                          decoration:
                              const InputDecoration(labelText: 'Add Points'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final pointsToAdd =
                                double.tryParse(controller.addPoints.text);
                            if (pointsToAdd != null) {
                              controller.adminAddUserPoints(
                                  pointsToAdd, user.id.toString());
                            } else {
                              HelperShackBar.errorSnackBar(
                                  title: 'Invalid Input',
                                  message: 'Please enter a valid number.');
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TSectionHeading(
                    title: 'Access Privileges'.toUpperCase(),
                    showActionButton: false,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          'User Type',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      const Text(':'),
                      const SizedBox(width: 8),
                      Obx(() {
                        return DropdownButton<AppRole>(
                          value: controller.userType.value,
                          onChanged: (AppRole? newValue) {
                            if (newValue != null) {
                              controller.userType.value = newValue;
                            }
                          },
                          items: AppRole.values.map<DropdownMenuItem<AppRole>>(
                            (AppRole value) {
                              return DropdownMenuItem<AppRole>(
                                value: value,
                                child: Text(value.toString().split('.').last),
                              );
                            },
                          ).toList(),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.updateAdminUserProfile.currentState!
                            .validate()) {
                          UserController.instance.updateUserAdmin(user);
                        }
                      },
                      child: const Text("Update"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
