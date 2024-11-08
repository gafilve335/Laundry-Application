import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import '../../../utils/constants/sizes.dart';

class THorizontalProductShimmer extends StatelessWidget {
  const THorizontalProductShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwSections),
      height: 120,
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) =>
            const SizedBox(width: TSizes.spaceBtwItems),
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              TShimmerEffect(width: 300, height: 140),
              SizedBox(width: TSizes.spaceBtwItems),

              /// Text
              SizedBox(height: TSizes.spaceBtwItems / 2),
              TShimmerEffect(width: 160, height: 15),
              SizedBox(height: TSizes.spaceBtwItems / 2),
              TShimmerEffect(width: 110, height: 15),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
