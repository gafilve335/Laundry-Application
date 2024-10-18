import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundry_mobile/app.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/firebase_options.dart';

Future<void> main() async {
  // -- Create Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // -- GetStorage Initialize
  await GetStorage.init();

  // -- Firebase Initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((_) => Get.put(AuthenticationRepository()));

  //  -- จะเริ่ม Run App หลัง ทำขั้นตอนก่อนหน้าสำเร็จ
  runApp(const App());
}
