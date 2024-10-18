import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/controller/support/support_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class ReportForm extends StatelessWidget {
  const ReportForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.find<SupportController>();
    return TRoundedContainer(
      showBorder: true,
      backgroundColor: isDark ? TColors.darkContainer : TColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TSectionHeading(
                title: 'Report a problem'.toUpperCase(),
                showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextFormField(
              maxLines: 8,
              controller: controller.support,
              validator: (value) =>
                  TValidator.validateEmptyText('Report', value),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.processReport();
                },
                child: Text(
                  'Submit'.toUpperCase(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}