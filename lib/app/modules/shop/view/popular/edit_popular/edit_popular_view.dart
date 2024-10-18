import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/popular/edit_popular/widgets/edit_popular_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class EditPopularView extends StatelessWidget {
  const EditPopularView({super.key});

  @override
  Widget build(BuildContext context) {
    final popular = Get.arguments;

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Edit Popular'.toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditPopularForm(popular: popular),
            ],
          ),
        ),
      ),
    );
  }
}
