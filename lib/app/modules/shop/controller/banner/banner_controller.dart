import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/banner_model.dart';
import 'package:laundry_mobile/app/data/repositories/banners/banners_repository.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();
  final isLoading = false.obs;
  final allbannerLoding = false.obs;
  final carousalCurrentIndex = 0.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxList<BannerModel> allBanners = <BannerModel>[].obs;

  @override
  void onInit() {
    fetcBanners();
    fetcAllBanners();
    super.onInit();
  }

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  /// Fetch Banners
  Future<void> fetcBanners() async {
    try {
      isLoading.value = true;
      //Fetch Banners
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fecthBanners();

      // Assign Banners
      this.banners.assignAll(banners);
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_BANNER',
          message: 'An error occurred while fetching data from the database');
    } finally {
      // await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
    }
  }

  Future<void> fetcAllBanners() async {
    try {
      allbannerLoding.value = true;
      //Fetch Banners
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.getAllBanners();

      // Assign Banners
      allBanners.assignAll(banners);
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_ALLBANNER',
          message: 'An error occurred while fetching data  from the database');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      allbannerLoding.value = false;
    }
  }

  Future<void> deleteBanner(String bannerId) async {
    try {
      // Delete the banner with the specified ID from Firestore
      final bannerRepo = Get.put(BannerRepository());
      await bannerRepo.deleteBanner(bannerId);

      // Reload banners after deletion
      await fetcAllBanners();
      await fetcBanners();
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_DELETE_BANNER',
          message: 'An error occurred while delete data  from the database');
    } finally {
      // await Future.delayed(const Duration(seconds: 1));
    }
  }
}
