import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/style/spacing_styles.dart';
import 'package:laundry_mobile/app/common/widgets/form/form_divider_widget.dart';
import 'package:laundry_mobile/app/common/widgets/form/form_header_widget.dart';
import 'package:laundry_mobile/app/common/widgets/form/social_footer.dart';
import 'package:laundry_mobile/app/modules/authentication/view/login/widgets/login_form_wiget.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import '../../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TspacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //วิตเจ็ตการจัดวางรูปภาพ
              FormHeaderWidget(
                image: TImages.appLogo,
                title: TTexts.tLoginTitle,
                subTitle: TTexts.tLoginSubTitle,
              ),

              SizedBox(height: TSizes.spaceBtwSections),

              //ฟอร์มการเข้าสู่ระบบ
              LoginFromWidget(),
              SizedBox(height: TSizes.spaceBtwSections),
              TFormDividerWidget(),

              //Google and facrbook Signin
              SocailFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
