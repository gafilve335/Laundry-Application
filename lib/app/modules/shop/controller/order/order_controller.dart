import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/order_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/data/repositories/order/order_repository.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final orderRepository = Get.put(OrderRepository());
  final RxList<OrderModel> order = <OrderModel>[].obs;
  //final Map arguments = Get.arguments;
  final isLoading = false.obs;
  final isLoadingFetchAll = false.obs;
  // Pagination fields
  final RxInt currentPage = 0.obs;
  final int rowsPerPage = 10; // Number of rows per page

  @override
  void onInit() {
    fetchUserOrders();
    super.onInit();
  }

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userid = AuthenticationRepository.instance.authUser?.uid;
      if (userid == null || userid.isEmpty) return [];

      isLoading.value = true;
      final userOrders = await orderRepository.fetchUserOrders(userid);
      order.addAll(userOrders);
      return userOrders;
    } catch (e) {
      HelperShackBar.errorSnackBar(title: 'ERROR_ORDER');
      TLoggerHelper.error(
          'An error occurred while fetching data  from the database');
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<OrderModel>> fetchUserSingleOrders(String userId) async {
    try {
      isLoadingFetchAll.value = true;
      final userOrders = await orderRepository.fetchUserOrders(userId);
      order.assignAll(
          userOrders); // Use assignAll to replace the list instead of addAll
      return userOrders;
    } catch (e) {
      HelperShackBar.errorSnackBar(title: 'ERROR_ORDER');
      TLoggerHelper.error(
          'An error occurred while fetching data from the database');
      return [];
    } finally {
      isLoadingFetchAll.value = false;
    }
  }
}
