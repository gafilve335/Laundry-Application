import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/laundry_popular_model.dart';
import 'package:laundry_mobile/app/data/repositories/popular/popular_repository.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';

class LaundryPopularController extends GetxController {
  static LaundryPopularController get instance => Get.find();
  final isLoading = false.obs;
  final allPopularLoading = false.obs;
  final RxList<LaundryPopularModel> laundrypopular =
      <LaundryPopularModel>[].obs;
  final RxList<LaundryPopularModel> allLaundrypopular =
      <LaundryPopularModel>[].obs;

  @override
  void onInit() {
    fetcLaundryPopular();
    fetcAllPopular();
    super.onInit();
  }

  /// Fetch Banners
  Future<void> fetcLaundryPopular() async {
    try {
      isLoading.value = true;

      //Fetch Banners
      final laundryRepo = Get.put(PopularRepository());
      final popularbanners = await laundryRepo.fecthLaundryPopula();

      // Assign Banners
      laundrypopular.assignAll(popularbanners);
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_HOME',
          message: 'An error occurred while fetching data  from the database');
    } finally {
      // await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
    }
  }

  Future<void> fetcAllPopular() async {
    try {
      allPopularLoading.value = true;
      //Fetch Banners
      final popularRepo = Get.put(PopularRepository());
      final popular = await popularRepo.getAllPopular();

      // Assign Banners
      allLaundrypopular.assignAll(popular);
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_ALLBANNER',
          message: 'An error occurred while fetching data  from the database');
    } finally {
      allPopularLoading.value = false;
      //await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<void> deletePopular(String popularId) async {
    try {
      // Delete the banner with the specified ID from Firestore
      final popularRepo = Get.put(PopularRepository());
      await popularRepo.deletePopular(popularId);

      // Reload banners after deletion
      await fetcAllPopular();
      await fetcLaundryPopular();
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_DELETE_BANNER',
          message: 'An error occurred while delete data  from the database');
    } finally {
      // await Future.delayed(const Duration(seconds: 1));
    }
  }
}
