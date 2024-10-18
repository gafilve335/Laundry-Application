import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/common/layout/listview_layout.dart';
import 'package:laundry_mobile/app/common/style/product_title_text.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/data/models/laundry_popular_model.dart';
import 'package:laundry_mobile/app/modules/shop/controller/location/location_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/popular_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';
import 'package:map_launcher/map_launcher.dart';

class MapHorizontal extends StatelessWidget {
  const MapHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = LaundryPopularController.instance;
    final profile = ProfileController.instance;
    final locationController = Get.put(LocationController());

    return SizedBox(
      height: 220,
      child: Obx(() {
        if (controller.isLoading.value) {
          return THorizontalProductShimmer(
            itemCount: controller.laundrypopular.length,
          );
        } else {
          return TListView(
            itemCount: controller.laundrypopular.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final laundryItem = controller.laundrypopular[index];
              return _buildLaundryItemCard(context, isDark, laundryItem,
                  profile, locationController, index);
            },
          );
        }
      }),
    );
  }

  Widget _buildLaundryItemCard(
      BuildContext context,
      bool isDark,
      LaundryPopularModel laundryItem,
      ProfileController profile,
      LocationController locationController,
      int index) {
    // ปรับขนาดตามหน้าจอโดยใช้ MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.72; // ปรับขนาดให้สัมพันธ์กับหน้าจอ

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? TColors.darkerGrey : TColors.white,
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.1),
            blurRadius: 0.5,
            spreadRadius: 0.5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              _buildLaundryImage(laundryItem, cardWidth),
              _buildEditButton(profile, laundryItem),
            ],
          ),
          _buildLocationStatus(laundryItem, locationController, index, context),
        ],
      ),
    );
  }

  Widget _buildLaundryImage(LaundryPopularModel laundryItem, double cardWidth) {
    return TRoundedImage(
      image: laundryItem.imageUrl,
      imageType: ImageType.network,
      fit: BoxFit.cover,
      borderRadius: 10,
      height: 140,
      width: cardWidth,
      onPressed: () async {
        final availableMaps = await MapLauncher.installedMaps;
        await availableMaps.first.showMarker(
          coords:
              Coords(laundryItem.destinationLat, laundryItem.destinationLon),
          title: laundryItem.titleMapLauncher,
        );
      },
    );
  }

  Widget _buildLocationStatus(LaundryPopularModel laundryItem,
      LocationController locationController, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TProductTitleText(
            title: laundryItem.name.toUpperCase(),
            smallSize: true,
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                size: 15,
                color: TColors.grey,
              ),
              Obx(() {
                if (locationController.isLoading.value) {
                  return const TShimmerEffect(width: 250, height: 15);
                } else {
                  final distance = locationController.distances.length > index
                      ? locationController.distances[index]
                      : "Unknown distance"; // เพิ่มการแสดงเมื่อไม่มีข้อมูลระยะทาง

                  return Text(
                    '$distance | ${laundryItem.address} ',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(
      ProfileController profile, LaundryPopularModel laundryItem) {
    return Positioned(
      top: 10,
      right: 10,
      child: TRoundedContainer(
        backgroundColor: TColors.primary,
        child: Visibility(
          visible: profile.user.value.role == AppRole.admin,
          child: IconButton(
            icon: const Icon(Iconsax.edit),
            color: TColors.white,
            onPressed: () => Get.toNamed(
              AppScreens.editPopular,
              arguments: laundryItem,
            ),
          ),
        ),
      ),
    );
  }
}
