import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'notification_service.dart';
import '../../common/ui.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    firebaseCloudMessagingListeners();
    return this;
  }

  void firebaseCloudMessagingListeners() {
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Get.isRegistered<RootController>()) {
        Get.find<RootController>().getNotificationsCount();
      }
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        _newMessageNotification(message);
      } else {
        _defaultNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        if (Get.isRegistered<RootController>()) {
          Get.find<RootController>().changePage(2);
        }
      } else {
        if (Get.isRegistered<RootController>()) {
          Get.find<RootController>().changePage(1);
        }
      }
    });
  }

  Future<void>  setDeviceToken() async {
    try{
      print("TEST_CHECK -> ");
       await FirebaseMessaging.instance.requestPermission();
   String token = await FirebaseMessaging.instance.getToken();
      print("TEST_CHECK -> ${token}");
      Get.find<AuthService>().user.value.deviceToken =
      await FirebaseMessaging.instance.getToken();
     }catch(e){

    }

  }

  void _defaultNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    var title = "";
    if (notification.title.toString().contains("{\"en\":")) {
      title = "New Booking";
    } else title = notification.title;
    NotificationService()
        .showNotification(title: title, body: notification.body);
  }

  void _newMessageNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    print(message.data);
    if (Get.find<MessagesController>().initialized) {
      Get.find<MessagesController>().refreshMessages();
    }
    if (Get.currentRoute != Routes.CHAT) {
      NotificationService()
          .showNotification(title: notification.title, body: notification.body);
    }
  }
}
