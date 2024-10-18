import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/banner_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/popular_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/modules/shop/view/home/widgets/home_appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/home/widgets/home_product.dart';
import 'package:laundry_mobile/app/modules/shop/view/home/widgets/home_popular.dart';
import 'package:laundry_mobile/app/modules/shop/view/home/widgets/home_banner.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import '../../controller/location/location_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _refreshData() {
    return Future.delayed(const Duration(milliseconds: 1)).then((_) {
      Get.find<LaundryPopularController>().fetcLaundryPopular();
      Get.find<LocationController>().fetcCalculateDistance();
      Get.find<BannerController>().fetcBanners();
      Get.find<ProductCardController>().fetchProductCard();
      //Get.find<ProductCardController>().fetchMqttStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: THomeAppBar(),
      ),
      body: RefreshIndicator(
        color: TColors.primary,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: TBanner()),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Row(
                children: [
                  SizedBox(width: TSizes.lg),
                  TSectionHeading(
                    showActionButton: false,
                    title: 'P O P U L A R   L A U N D R Y',
                  )
                ],
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.all(3),
                child: MapHorizontal(),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                children: [
                  const SizedBox(width: TSizes.lg),
                  TSectionHeading(
                    showActionButton: false,
                    showSubtitle: true,
                    title: 'M A C H I N E   S T A T U S',
                    subTitle: 'List of responsive Washer'.toUpperCase(),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(TSizes.md),
                child: Column(
                  children: [
                    TProductCardVertical(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
