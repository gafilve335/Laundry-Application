import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:laundry_mobile/app/data/repositories/order/order_repository.dart';
import 'package:laundry_mobile/app/modules/shop/controller/order/order_controller.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/pricing_calculator.dart';

class CheckOutController extends GetxController {
  static OrderController get instance => Get.find();

  late final RxDouble priceAfterDiscount = 0.0.obs;
  final Map arguments = Get.arguments;
  final orderRepository = Get.put(OrderRepository());

  @override
  void onInit() {
    super.onInit();
    calculatePriceAfterDiscount();
  }

  void calculatePriceAfterDiscount() {
    final productItem = Get.arguments['index'];

    // ตรวจสอบว่า productItem ไม่เป็น null ก่อนที่จะดำเนินการต่อ
    if (productItem != null) {
      final double price = productItem.price ?? 0.0;
      final double discount = productItem.discount ?? 0.0;

      // ตรวจสอบว่า price และ discount มีค่าเป็นเลขบวกก่อนที่จะคำนวณ
      if (price >= 0 && discount >= 0) {
        priceAfterDiscount.value =
            TPricingCalculator.calculatePriceAfterDiscount(price, discount);
      } else {
        HelperShackBar.errorSnackBar(
            title: 'ERROR_PAYMENT',
            message: 'Error: Price or discount cannot be negative.');
        //TLoggerHelper.error('Error: Price or discount cannot be negative.');
      }
    } else {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_PAYMENT', message: 'Error: No product item found.');
      //TLoggerHelper.error('Error: No product item found.');
    }
  }

  bool checkIfProductIsDiscounted(ProductCardModel productItem) {
    return productItem.discount != 0;
  }
}
