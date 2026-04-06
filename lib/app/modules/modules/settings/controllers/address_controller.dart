import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/setting_repository.dart';
import '../../../services/auth_service.dart';

class AddressController extends GetxController {
  SettingRepository _settingRepository;
  final addresses = <Address>[].obs;
  EServiceRepository _eServiceRepository;
  // SharedPrefUtils pref = SharedPrefUtils();

  AddressController() {
    _settingRepository = new SettingRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  void onInit() async {
    await refreshAddresses();
    super.onInit();
  }

  Future refreshAddresses({bool showMessage}) async {
    await getAddresses();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of addresses refreshed successfully".tr));
    }
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await _settingRepository.getAddresses());
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<bool> validateCity(Address address) async {
    var serviceAvailable = false;
    var lat = address.latitude.toString();
    var lng = address.longitude.toString();
    try {
      serviceAvailable = await _eServiceRepository.checkCity(lat, lng,zipcode: address.zipCode);
      // pref.saveBooleanToPref(SharedPrefUtils.SERVICE_AVAILABLE, serviceAvailable);
      // pref.saveBooleanToPref(SharedPrefUtils.REGION_VERIFIED, true);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      // pref.saveBooleanToPref(SharedPrefUtils.SERVICE_AVAILABLE, false);
      // pref.saveBooleanToPref(SharedPrefUtils.REGION_VERIFIED, false);
    }
    return serviceAvailable;
  }
}
