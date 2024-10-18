import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return AppBar(
      elevation: 2,
      centerTitle: false,
      backgroundColor: isDark ? TColors.black : TColors.white,

      ///* title
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.home, size: 25, color: TColors.primary),
              const SizedBox(width: 10),
              Text(
                'H O M E',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
