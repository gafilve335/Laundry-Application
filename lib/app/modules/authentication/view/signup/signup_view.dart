import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/form/form_divider_widget.dart';
import 'package:laundry_mobile/app/common/widgets/form/social_footer.dart';
import 'package:laundry_mobile/app/modules/authentication/controller/signup_controller.dart';
import 'package:laundry_mobile/app/modules/authentication/view/signup/widgets/signup_form_widget.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.offNamed(AppScreens.login),
              icon: const Icon(
                Icons.clear,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*Title
              Text(
                TTexts.sighupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const SignupFormWidget(),
              const SizedBox(height: TSizes.spaceBtwSections - 7),
              const TFormDividerWidget(),
              const SocailFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
