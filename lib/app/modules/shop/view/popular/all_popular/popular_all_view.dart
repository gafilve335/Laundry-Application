import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/popular/all_popular/widgets/popular_all_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class PopularAllView extends StatelessWidget {
  const PopularAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        title: Text('POPULAR'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.md),
          child: Column(
            children: [AllPopularForm()],
          ),
        ),
      ),
    );
  }
}
