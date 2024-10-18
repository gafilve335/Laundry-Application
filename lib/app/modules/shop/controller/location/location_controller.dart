import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/laundry_popular_model.dart';
import 'package:laundry_mobile/app/data/repositories/popular/popular_repository.dart';
import 'package:laundry_mobile/app/data/services/location_service.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';

class LocationController extends GetxController {
  static LocationController get instance => Get.find();

  final RxList<LaundryPopularModel> laundrypopular =
      <LaundryPopularModel>[].obs;
  final RxList<String> distances = <String>[].obs;

  RxString address = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() async {
    await fetclaundry();
    await determinePosition();
    await getCurrentLocation();
    await fetcCalculateDistance();
    super.onInit();
  }

  Future<void> fetclaundry() async {
    try {
      //Fetch Banners
      final laundryRepo = Get.put(PopularRepository());
      final popularbanners = await laundryRepo.fecthLaundryPopula();

      // Assign Banners
      laundrypopular.assignAll(popularbanners);
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_NETWORK_LOCATION', message: e.toString());
    } finally {}
  }

  Future<void> determinePosition() async {
    try {
      await LocationService().determinePosition();
    } catch (e) {
      TLoggerHelper.error(
          "ERROR_NETWORK_LOCATION :: Controller DeterminePosition $e");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      await LocationService().getCurrentLocation();
    } catch (e) {
      TLoggerHelper.error(
          "ERROR_NETWORK_LOCATION :: Controller getCurrentLocation $e");
    }
  }

  Future<void> fetcCalculateDistance() async {
    try {
      isLoading.value = true;
      distances.clear();

      await fetclaundry();

      for (LaundryPopularModel laundry in laundrypopular) {
        double destinationLat = laundry.destinationLat;
        double destinationLon = laundry.destinationLon;

        double distanceInKm =
            await DistanceCalculatorService(destinationLat, destinationLon)
                .calculateDistance();

        distances.add("${distanceInKm.toStringAsFixed(2)} km");
      }

      isLoading.value = false;
    } catch (e) {
      HelperShackBar.warningSnackBar(
          title: 'ERROR_NETWORK_LOCATION',
          message: 'Location permissions are denied');
      // TLoggerHelper.error("Error Controller fetcCalculateDistance $e");
      isLoading.value = false;
      address.value = "";
    }
  }
}
