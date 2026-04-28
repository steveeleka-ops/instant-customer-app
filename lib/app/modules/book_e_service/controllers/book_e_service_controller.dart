import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/setting_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class BookEServiceController extends GetxController {
  final scheduled = false.obs;
  final recurrence = ''.obs; // '', 'weekly', 'biweekly', 'monthly'
  final booking = Booking().obs;
  final addresses = <Address>[].obs;
  BookingRepository _bookingRepository;
  SettingRepository _settingRepository;

  Address get currentAddress => Get.find<SettingsService>().address.value;

  BookEServiceController() {
    _bookingRepository = BookingRepository();
    _settingRepository = SettingRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    final _eService = (Get.arguments['eService'] as EService);
    scheduled.value = !_eService.eProvider.available;
    final _options = (Get.arguments['options'] as List<Option>);
    final _quantity = (Get.arguments['quantity'] as int);
    var bookingAt ;
    if(scheduled.value) bookingAt = DateTime.now().add(Duration(days: 1));
    else bookingAt = DateTime.now();

    this.booking.value = Booking(
      bookingAt: bookingAt,
      address: currentAddress,
      eService: _eService,
      eProvider: _eService.eProvider,
      taxes: _eService.eProvider.taxes,
      options: _options,
      quantity: _quantity,
      user: Get.find<AuthService>().user.value,
      coupon: new Coupon(),
    );
    print("TEST_CHECK -> ${booking.value.bookingAt}");
    await getAddresses();
  }

  @override
  void update([ids, bool condition = true]) {
    print("fsdfsdf");
  }

  void toggleScheduled(value) {
    scheduled.value = value;
    if (!value) recurrence.value = '';
  }

  void toggleRecurrence(value) {
    recurrence.value = value ?? '';
    if (recurrence.value.isNotEmpty) {
      scheduled.value = true;
    }
  }

  TextStyle getTextTheme(bool selected) {
    if (selected) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  Color getColor(bool selected) {
    if (selected) {
      return Get.theme.colorScheme.secondary;
    }
    return null;
  }

  void createBooking() async {
    try {
      this.booking.value.address = currentAddress;
      this.booking.value.recurrence = recurrence.value.isNotEmpty ? recurrence.value : null;
      Get.log(booking.value.toString());
      print(booking.value);
      // Create booking to get an ID, then send customer to Stripe to authorize payment hold
      final createdBooking = await _bookingRepository.add(booking.value);
      booking.value = createdBooking;
      // Navigate to Stripe checkout — funds held until job is approved by customer
      Get.toNamed(Routes.STRIPE, arguments: {'booking': createdBooking});
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await _settingRepository.getAddresses());
        if (!currentAddress.isUnknown()) {
          addresses.remove(currentAddress);
          addresses.insert(0, currentAddress);
        }
        if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
          Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id;
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void validateCoupon() async {
    try {
      Coupon _coupon = await _bookingRepository.coupon(booking.value);
      booking.update((val) {
        val.coupon = _coupon;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  String getValidationMessage() {
    if (booking.value.coupon?.id == null) {
      return null;
    } else {
      if (booking.value.coupon.id == '') {
        return "Invalid Coupon Code".tr;
      } else {
        return null;
      }
    }
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: booking.value.bookingAt.add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      booking.update((val) {
        val.bookingAt = DateTime(picked.year, picked.month, picked.day, val.bookingAt.hour, val.bookingAt.minute);
        ;
      });
    }
  }

  Future<Null> showMyTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(booking.value.bookingAt),
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      booking.update((val) {
        val.bookingAt = DateTime(booking.value.bookingAt.year, booking.value.bookingAt.month, booking.value.bookingAt.day).add(Duration(minutes: picked.minute + picked.hour * 60));
      });
    }
  }
}
