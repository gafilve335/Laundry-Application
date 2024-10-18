import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/create_product/widgets/create_product_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class CreateProductView extends StatelessWidget {
  const CreateProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Create Washer'.toUpperCase()),
      ),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [CreateProductForm()],
          ),
        ),
      ),
    );
  }
}
