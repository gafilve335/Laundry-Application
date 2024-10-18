import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/banner/edit_banner/widgets/edit_banner_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class EditBannerView extends StatelessWidget {
  const EditBannerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final banner = Get.arguments; // แปลง arguments เป็น BannerModel
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Update Banner'.toUpperCase(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form
              EditBannerForm(banner: banner),
            ],
          ),
        ),
      ),
    );
  }
}
