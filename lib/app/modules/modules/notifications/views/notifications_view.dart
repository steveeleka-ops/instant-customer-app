import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsView extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => {Get.back()},
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          await controller.refreshNotifications(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: ListView(
          primary: true,
          children: <Widget>[
            Text("Incoming Notifications".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
            Text("Swipe item left to delete it.".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
            notificationsList(),
          ]
        ))
    );
  }

  Widget notificationsList() {
    return Obx(() {
      if (!controller.notifications.isNotEmpty) {
        return CircularLoadingWidget(
          height: 300,
          onCompleteText: "Notification List is Empty".tr,
        );
      } else {
        var _notifications = controller.notifications;
        return ListView.separated(
            itemCount: _notifications.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 7);
            },
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return NotificationItemWidget(
                notification: controller.notifications.elementAt(index),
                onDismissed: (notification) {
                  controller.removeNotification(notification);
                },
                onTap: (notification) async{
                    if(notification.data['message_id'] != null){
                      print(notification.data.toString());
                      Stream<QuerySnapshot> _userMessages;
                      _userMessages = controller.chatRepository.getUserMessages(controller.authService.user.value.id);
                      _userMessages.listen((QuerySnapshot query) {
                        if (query.docs.isNotEmpty) {
                          print('MESSSSAGGESSSSS ${query.docs.length}');
                          query.docs.forEach((element) {
                            Message message=     Message.fromDocumentSnapshot(element);
                            if(message.id == notification.data['message_id']){
                              controller.markAsReadNotification(notification);
                              Get.toNamed(Routes.CHAT, arguments: message);
                              return;
                            }
                          });
                        }
                      });

                    }else{
                      controller.getBookingDetails(notification.data['booking_id'].toString()).then((value) => {
                        controller.isLoading.value = false,
                        Get.toNamed(Routes.BOOKING, arguments: value),
                        controller.markAsReadNotification(notification)
                      });
                    }

                },
              );
            });
      }
    });
  }
}
