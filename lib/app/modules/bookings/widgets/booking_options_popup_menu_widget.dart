import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../controllers/bookings_controller.dart';
import 'booking_actions_widget.dart';

class BookingOptionsPopupMenuWidget extends GetView<BookingsController> {
  const BookingOptionsPopupMenuWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    final int statusOrder = _booking.status?.order ?? 0;
    final int done = Get.find<GlobalService>().global.value.done; // 50
    final int onTheWay =
        Get.find<GlobalService>().global.value.onTheWay; // 20

    final bool canCancel =
        !_booking.cancel && statusOrder > 0 && statusOrder < done;
    final bool isLateCancel = statusOrder >= onTheWay;

    return PopupMenuButton(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (item) {
        switch (item) {
          case "cancel":
            {
              if (isLateCancel) {
                Get.dialog(LateCancelDialog(
                  totalAmount: _booking.getTotal(),
                  onConfirm: () {
                    controller.cancelBookingService(_booking);
                  },
                ));
              } else {
                Get.dialog(FreeCancelDialog(
                  onPressed: () {
                    controller.cancelBookingService(_booking);
                    Get.back();
                  },
                ));
              }
            }
            break;
          case "view":
            {
              Get.toNamed(Routes.BOOKING, arguments: _booking);
            }
            break;
        }
      },
      itemBuilder: (context) {
        var list = <PopupMenuEntry<Object>>[];
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "ID #".tr + _booking.id,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "View Details".tr,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        if (canCancel) {
          list.add(PopupMenuDivider(height: 10));
          list.add(
            PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                  Text(
                    isLateCancel ? "Cancel (10% fee)".tr : "Cancel".tr,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
              value: "cancel",
            ),
          );
        }
        return list;
      },
      child: Icon(
        Icons.more_vert,
        color: Get.theme.hintColor,
      ),
    );
  }
}
