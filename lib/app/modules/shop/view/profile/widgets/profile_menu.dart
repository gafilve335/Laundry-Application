import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class TProfileMenu extends StatelessWidget {
  const TProfileMenu(
      {super.key,
      this.icon = Iconsax.arrow_right_34,
      required this.onPressed,
      required this.title,
      required this.value,
      this.showActionButton = true});

  final IconData icon;
  final VoidCallback onPressed;
  final String title, value;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                )),
            Expanded(
                flex: 5,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                )),
            if (showActionButton)
              Expanded(
                  child: Icon(
                icon,
                size: 18,
                color: TColors.primary,
              ))
          ],
        ),
      ),
    );
  }
}