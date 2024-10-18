import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/layout/listview_layout.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/image_circular.dart';
import 'package:laundry_mobile/app/modules/shop/controller/user/user_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class UserAllForm extends StatelessWidget {
  const UserAllForm({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Padding(
      padding: const EdgeInsets.all(TSizes.md),
      child: Obx(() {
        return TListView(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.users.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final userItem = controller.users[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TRoundedContainer(
                showBorder: false,
                radius: 2,
                backgroundColor: TColors.white,
                child: ListTile(
                  title: Text(
                    userItem.fullName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(userItem.email,
                      style: Theme.of(context).textTheme.labelMedium),
                  leading: TCircularImage(
                    image: userItem.profilePicture,
                    isNetworkImage: true,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.toNamed(AppScreens.userDetails,
                              arguments: userItem);
                        },
                        icon: const Icon(Iconsax.edit),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.trash,
                            color: TColors.error,
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
