import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;
  LatLng currentLocation;

  // var hasLocationService = false.obs;
  // var hasLocationPermission = false.obs;
  // var permissionPermanentlyRejected = false.obs;
  // var serviceAvailable = true.obs;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;
  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    // await getCurrentLocation();
    await getSlider();
    await getCategories();
    await getFeatured();
    await getRecommendedEServices();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

/*
  Future<void> getCurrentLocation() async {
    double lat = await pref.getDoubleFromPref(SharedPrefUtils.LATITUDE);
    double lng = await pref.getDoubleFromPref(SharedPrefUtils.LONGITUDE);
    var regionVerified = await pref.getBooleanFromPref(SharedPrefUtils.REGION_VERIFIED) ?? false;

    if (lat != null && lng != null) {
      currentLocation = LatLng(lat, lng);
      hasLocationService.value = true;
      hasLocationPermission.value = true;
      // if (regionVerified != null && regionVerified) serviceAvailable.value = true;
    } else {
      await Utils.getCurrentLocation().then((value) {
        currentLocation = LatLng(value.latitude, value.longitude);
        pref.saveDoubleToPref(SharedPrefUtils.LATITUDE, value.latitude);
        pref.saveDoubleToPref(SharedPrefUtils.LONGITUDE, value.longitude);
        hasLocationService.value = true;
        hasLocationPermission.value = true;
      }).catchError((error) {
        // Utils.showAlertDialog(Get.context, error);
        switch (error) {
          case Utils.LOCATION_SERVICE_UNAVAILABLE:
            {
              hasLocationService.value = false;
              hasLocationPermission.value = false;
              permissionPermanentlyRejected.value = false;
              break;
            }
          case Utils.LOCATION_PERMISSION_DENIED:
            {
              hasLocationService.value = true;
              hasLocationPermission.value = false;
              permissionPermanentlyRejected.value = false;
              break;
            }
          case Utils.LOCATION_PERMISSION_PERMANENTLY_DENIED:
            {
              hasLocationService.value = true;
              hasLocationPermission.value = false;
              permissionPermanentlyRejected.value = true;
              break;
            }
          default:
            {
              hasLocationService.value = true;
              hasLocationPermission.value = true;
              permissionPermanentlyRejected.value = false;
              break;
            }
        }
      });
    }
  }
*/

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

/*
  Future validateCity() async {
    try {
      var lat = currentLocation.latitude;
      var lng = currentLocation.longitude;
      String zipcode;
      await getZipCode(lat, lng).then((value) async => {
            zipcode = value.toString().replaceRange(value.toString().length-1, value.toString().length, ""),
            // zipcode = value.toString(),
            serviceAvailable.value = await _eServiceRepository.checkCity("$lat", "$lng", zipcode: zipcode),
            pref.saveBooleanToPref(SharedPrefUtils.SERVICE_AVAILABLE, serviceAvailable.value),
            pref.saveBooleanToPref(SharedPrefUtils.REGION_VERIFIED, true)
          });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      pref.saveBooleanToPref(SharedPrefUtils.SERVICE_AVAILABLE, false);
      pref.saveBooleanToPref(SharedPrefUtils.REGION_VERIFIED, false);
    }
  }

  Future getZipCode(double lat, double lng) async {
    final apiKey = 'AIzaSyDnp14uF9QJ1eh5-7ITZPehkPeEN7IKuyo';
    final apiUrl ='https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'];
        if (results.isNotEmpty) {
          final addressComponents = results[0]['address_components'];
          for (var component in addressComponents) {
            final types = component['types'];
            if (types.contains('postal_code')) {
              return component['long_name'];
            }
          }
        }
      }
    } catch (e) {
      return "12345";
    }
  }

  Future updateVariable(bool newValue) async {
    hasLocationService.value = newValue;
  }
*/
}
