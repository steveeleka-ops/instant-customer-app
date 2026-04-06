import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../book_e_service/controllers/book_e_service_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../controllers/address_controller.dart';
class AddressPickerView extends StatefulWidget {
  AddressPickerView();

  @override
  State<AddressPickerView> createState() => _AddressPickerViewState();
}

class _AddressPickerViewState extends State<AddressPickerView> {
  var isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: "AIzaSyDnp14uF9QJ1eh5-7ITZPehkPeEN7IKuyo",
      // "AIzaSyBjhakLbVKihjwgrd5CZCcTaA6HNLUKO_U",
      // Get.find<SettingsService>().setting.value.googleMapsKey,
      initialPosition: Get.find<SettingsService>().address.value.getLatLng(),
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePlaceDetailSearch: true,
      forceSearchOnZoomChanged: true,
      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused)  {
        if (isSearchBarFocused) {
          return SizedBox();
        }
        if (selectedPlace != null) {
          print('Addrresss' + selectedPlace?.formattedAddress ?? '');
        }
        Address _address = Address(address: selectedPlace?.formattedAddress ?? '');

        selectedPlace?.addressComponents?.forEach((element) {
          if (element.types.contains("postal_code")) {
            _address.zipCode = element.longName;
          }
        });

        return FloatingCard(
          height: 388,
          elevation: 0,
          bottomPosition: 0.0,
          leftPosition: 0.0,
          rightPosition: 0.0,
          color: Colors.transparent,
          child: state == SearchingState.Searching
              ? Center(child: CircularProgressIndicator())
              : Container(
                  width: double.infinity,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "Description".tr,
                        hintText: "My Home".tr,
                        initialValue: _address.description,
                        onChanged: (input) => _address.description = input,
                        iconData: Icons.description_outlined,
                        isFirst: true,
                        isLast: false,
                        enabled: isLoading.isFalse,
                      ),
                      TextFieldWidget(
                        labelText: "Full Address".tr,
                        hintText: "123 Street, City 136, State, Country".tr,
                        initialValue: _address.address,
                        onChanged: (input) => _address.address = input,
                        iconData: Icons.place_outlined,
                        isFirst: false,
                        isLast: false,
                        enabled: isLoading.isFalse,
                      ),
                      TextFieldWidget(
                        labelText: "Zipcode".tr,
                        hintText: "123 Zipcode".tr,
                        initialValue: _address.zipCode ,
                        onChanged: (input) => _address.zipCode = input,
                        iconData: Icons.place_outlined,
                        isFirst: false,
                        isLast: true,
                        enabled: isLoading.isFalse,
                      ),
                      Stack(
                        children: [
                          isLoading.isTrue ? Container(
                              height: 46,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Get.theme.colorScheme.secondary
                              ),
                              child: Align(alignment: Alignment.center, child: CircularProgressIndicator(color: Colors.white))
                          ) : Container(width: double.maxFinite, child: BlockButtonWidget(
                            onPressed: () async {
                              Get.lazyPut(() => AddressController());
                              if(_address.zipCode != null && _address.zipCode.isNotEmpty){
                                FocusScope.of(context).unfocus();
                                setState(() => isLoading.value = true);
                                if(await Get.find<AddressController>().validateCity(_address)){
                                  Get.find<SettingsService>().address.update((val) async {
                                    val.description = _address.description;
                                    val.address = _address.address;
                                    val.latitude = selectedPlace.geometry.location.lat;
                                    val.longitude = selectedPlace.geometry.location.lng;
                                    val.userId = Get.find<AuthService>().user.value.id ?? "";
                                    val.zipCode = _address.zipCode ;
                                  });
                                  if (Get.isRegistered<BookEServiceController>()) {
                                    await Get.find<BookEServiceController>()
                                        .getAddresses();
                                  }
                                  if (Get.isRegistered<RootController>()) {
                                    await Get.find<RootController>().refreshPage(0);
                                  }
                                  if (Get.isRegistered<AuthController>()){
                                    Get.find<AuthController>().address.value = _address;
                                  }
                                  Get.back();
                                }
                                setState(() => isLoading.value = false);
                              } else Get.showSnackbar(Ui.ErrorSnackBar(message: "Zipcode should be more than 3 characters".tr));
                            },
                            color: Get.theme.colorScheme.secondary,
                            text: Text(
                              "Pick Here".tr,
                              style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                            ),
                          ))]
                      ).paddingSymmetric(horizontal: 20),
                      SizedBox(height: 10),
                    ],
                  )),
        );
      },
    );
  }
}
