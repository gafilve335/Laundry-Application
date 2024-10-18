import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/edit_product/widgets/bottom_navigation_widget.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/edit_product/widgets/edit_product_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class EditProductView extends StatelessWidget {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments;
    return Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product),
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Edit Washer'.toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProductForm(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
