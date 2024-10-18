import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';

class TFormDividerWidget extends StatelessWidget {
  const TFormDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
            child: Divider(
                thickness: 1, indent: 50, color: TColors.grey, endIndent: 10)),
        Text(
          TTexts.tOR,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Flexible(
            child: Divider(
          thickness: 1,
          indent: 10,
          color: TColors.grey,
          endIndent: 50,
        ))
      ],
    );
  }
}
