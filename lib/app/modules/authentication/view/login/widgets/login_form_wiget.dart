import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mobile/app/modules/authentication/controller/login_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import 'package:laundry_mobile/app/utils/validators/validation.dart';

class LoginFromWidget extends StatelessWidget {
  const LoginFromWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormkey,
      child: Column(
        children: [
          //ฟิลด์อีเมล์
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct),
              labelText: TTexts.email,
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),
          //ฟิลด์รหัสผ่าน
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) {
                return TValidator.validatePassword(value);
              },
              obscureText: controller.showPassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  //เมื่อเกิดการกด ตรวจสอบค่า ShowPassword true or false แล้วทำการ rebuild
                  onPressed: () => controller.showPassword.value =
                      !controller.showPassword.value,
                  icon: Icon(controller.showPassword.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //จดจำบัญชี
              Row(
                children: [
                  Obx(
                    //เมื่อค่าเกิดการเปลี่ยนแแปลง ตรวจสอบค่า rememberMe true or false แล้วทำการ rebuild
                    () => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) => controller.rememberMe.value =
                          !controller.rememberMe.value,
                    ),
                  ),
                  const Text(TTexts.rememberMe)
                ],
              ),

              //ลืมรหัสผ่าน
              TextButton(
                onPressed: () => Get.offNamed(AppScreens.forgotPassword),
                child: Text(TTexts.forgetPassword,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(color: TColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //ล็อคอิน
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.login(),
                  child: const Text(TTexts.login))),
          const SizedBox(height: TSizes.spaceBtwItems),

          //สร้างบัญชี
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.offNamed(AppScreens.signup),
              child: const Text(TTexts.createAccount),
            ),
          )
        ],
      ),
    );
  }
}
