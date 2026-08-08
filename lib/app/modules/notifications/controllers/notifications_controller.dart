import 'package:get/get.dart';
import 'package:home_services/app/models/e_provider_model.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/notification_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';
import '../../../providers/api_provider.dart';

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;
  final isLoading = false.obs;

  final eProvider = EProvider().obs;

  NotificationRepository _notificationRepository;
  BookingRepository _bookingRepository;
  EProviderRepository eProviderRepository;
  AuthService authService;

  ChatRepository chatRepository;


  NotificationsController() {
    _notificationRepository = new NotificationRepository();
    _bookingRepository = BookingRepository();
    eProviderRepository = new EProviderRepository();
    chatRepository = new ChatRepository();
    authService = Get.find<AuthService>();

  }

  @override
  void onInit() async {
    await refreshNotifications();
    super.onInit();
  }

  Future refreshNotifications({bool showMessage}) async {
    await getNotifications();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of notifications refreshed successfully".tr));
    }
  }

  Future getNotifications() async {
    try {
      notifications.assignAll(await _notificationRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future removeNotification(Notification notification) async {
    try {
      _notificationRepository.remove(notification).then((value) {
        if (!notification.read) {
          --Get.find<RootController>().notificationsCount.value;
        }
        notifications.remove(notification);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future markAsReadNotification(Notification notification) async {
    try {
      _notificationRepository.markAsRead(notification).then((value) {
        if (!notification.read) {
          notification.read = true;
          --Get.find<RootController>().notificationsCount.value;
        }
        notifications.refresh();
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<Booking> getBookingDetails(String bookingID) async {
    isLoading.value = true;
   return await _bookingRepository.get(bookingID);
  }
}
