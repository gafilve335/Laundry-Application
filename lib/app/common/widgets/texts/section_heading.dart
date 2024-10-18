import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';

class TSectionHeading extends StatelessWidget {
  const TSectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.buttonTitle = "View all",
    required this.title,
    this.showActionButton = true,
    this.icon = Icons.library_add_rounded,
    this.iconColor = TColors.primary,
    this.subTitle = "",
    this.showSubtitle = false,
  });

  final Color? textColor;
  final Color? iconColor;
  final bool showActionButton, showSubtitle;
  final String title, buttonTitle, subTitle;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 5),
            if (showSubtitle)
              Text(subTitle,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
          ],
        ),
        if (showActionButton)
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: iconColor,
              size: TSizes.iconLg,
            ),
          )
      ],
    );
  }
}
