import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/all_product/widgets/product_all_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class ProductAllView extends StatelessWidget {
  const ProductAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text('Washer'.toUpperCase()),
        showBackArrow: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.md),
          child: Column(
            children: [
              AllProductForm(),
            ],
          ),
        ),
      ),
    );
  }
}
