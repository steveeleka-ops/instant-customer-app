import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/global_service.dart';

class BookingsController extends GetxController {
  BookingRepository _bookingsRepository;

  final bookings = <Booking>[].obs;
  final bookingStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  // Kept for compatibility with checkout controllers that set this after payment.
  // No longer used to filter the booking list.
  final currentStatus = ''.obs;

  ScrollController scrollController;

  BookingsController() {
    _bookingsRepository = new BookingRepository();
  }

  @override
  Future<void> onInit() async {
    await getBookingStatuses();
    await loadBookings();
    super.onInit();
  }

  Future refreshBookings({bool showMessage = false}) async {
    bookings.clear();
    page.value = 0;
    isDone.value = false;
    await loadBookings();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Bookings page refreshed successfully".tr));
    }
  }

  void initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isDone.value) {
        loadBookings();
      }
    });
  }

  Future getBookingStatuses() async {
    try {
      bookingStatuses.assignAll(await _bookingsRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  BookingStatus getStatusByOrder(int order) =>
      bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      });

  Future loadBookings() async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Booking> _bookings =
          await _bookingsRepository.all(null, page: page.value);
      if (_bookings.isNotEmpty) {
        bookings.addAll(_bookings);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancels a booking. Works for any status — the fee warning dialog is
  /// shown by the UI layer before this is called.
  Future<void> cancelBookingService(Booking booking) async {
    try {
      final _status = getStatusByOrder(
          Get.find<GlobalService>().global.value.failed);
      final _booking =
          new Booking(id: booking.id, cancel: true, status: _status);
      await _bookingsRepository.update(_booking);
      bookings.removeWhere((element) => element.id == booking.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
