import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/services/mqtt_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/modules/shop/view/account/account_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/home/home_view.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    Get.put(ProfileController());
    Get.put(ProductCardController());
    final controller = Get.put(NavigationController());
    return Scaffold(
      // -- Navigation Controller Index
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 60,
          elevation: 0,
          backgroundColor: isDark ? TColors.black : TColors.white,
          indicatorColor: isDark ? TColors.darkGrey : TColors.lightGrey,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,

          // -- Navigation Screen
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.local_laundry_service,
                    color: isDark ? TColors.white : TColors.primary),
                label: 'W A S H E R'),
            NavigationDestination(
                icon: Icon(Icons.person,
                    color: isDark ? TColors.white : TColors.primary),
                label: 'A C C O U N T')
          ],
        ),
      ),
      body: Obx(() => controller.screen[controller.selectedIndex.value]),
    );
  }
}

// -- Navigation Controller
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    Get.find<MqttService>();
    //ProductCardController.instance.fetchMqttStatus();
  }

  final screen = [
    const HomeView(),
    const AccountView(),
  ];
}
