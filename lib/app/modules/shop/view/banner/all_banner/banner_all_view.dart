import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/banner/all_banner/widgets/banner_all_form.dart';

class BannerAllView extends StatelessWidget {
  const BannerAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        title: Text('BANNER'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AllBannerForm(),
          ],
        ),
      ),
    );
  }
}
