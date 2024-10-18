import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/popular/create_popular/widgets/create_popular_form.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class CreatePopularView extends StatelessWidget {
  const CreatePopularView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Create Popular'.toUpperCase()),
      ),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreatePopularForm(),
            ],
          ),
        ),
      ),
    );
  }
}
