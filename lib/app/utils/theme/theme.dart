import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/theme/widget/appbar_theme.dart';
import 'package:laundry_mobile/app/utils/theme/widget/checkbox_theme.dart';
import 'package:laundry_mobile/app/utils/theme/widget/elevated_button_theme.dart';
import 'package:laundry_mobile/app/utils/theme/widget/outlined_button_theme.dart';
import 'package:laundry_mobile/app/utils/theme/widget/text_field_theme.dart';
import 'package:laundry_mobile/app/utils/theme/widget/text_theme.dart';


// --> การตั้งค่าธีมการใช้งานเพื่อให้สามารถใช้ได้สองโหมดตามโหมดธีมของระบบ 
class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    disabledColor: TColors.grey,
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.light,
    textTheme: TTextTheme.lightTextTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    disabledColor: TColors.grey,
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    textTheme: TTextTheme.darkTextTheme,
    scaffoldBackgroundColor: TColors.black,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
  );
}
