import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:laundry_mobile/app/app_bindings.dart';
import 'package:laundry_mobile/app/routes/app_pages.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // --route
      initialBinding: AppBinding(),
      title: "Application",
      initialRoute: TAppRoute.inital,
      getPages: TAppRoute.pages,

      // --Theme
      // themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      //darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,

      // --Animation
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: const Scaffold(
        body: Center(
          child: SpinKitFadingFour(
            color: TColors.black,
          ),
        ),
      ),
    );
  }
}
