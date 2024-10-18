import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/banner/create_banner/widgets/create_banner_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class CreateBannerView extends StatelessWidget {
  const CreateBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text('Create Banner'.toUpperCase()),
        showBackArrow: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CerateBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
