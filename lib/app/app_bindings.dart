import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/services/mqtt_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/banner_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/coupons/coupons_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/order/order_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/popular_controller.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(MqttService(), permanent: true);

    Get.lazyPut(() => BannerController(), fenix: true);
    Get.lazyPut(() => LaundryPopularController(), fenix: true);
    Get.lazyPut(() => ProductCardController(), fenix: true);

    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => CouponsController(), fenix: true);
    //Get.lazyPut(() => WalletController(), fenix: true);
  }
}
