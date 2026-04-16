import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/booking_controller.dart';

class BookingActionsWidget extends GetView<BookingController> {
  const BookingActionsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _booking = controller.booking;
    return Obx(() {
      if (_booking.value.status != null &&
          _booking.value.status.order ==
              Get.find<GlobalService>().global.value.onTheWay) {
        return SizedBox(height: 0);
      } else {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        final int statusOrder = _booking.value.status?.order ?? 0;
        final int onTheWay =
            Get.find<GlobalService>().global.value.onTheWay; // 20
        final int done = Get.find<GlobalService>().global.value.done; // 50

        // Show cancel button if: not already cancelled AND not done/beyond
        final bool canCancel =
            !_booking.value.cancel && statusOrder > 0 && statusOrder < done;

        // Late cancel = provider is already on the way or in progress
        final bool isLateCancel = statusOrder >= onTheWay;

        return Container(
          padding: EdgeInsets.only(top: 10, bottom: 10 + bottomPadding),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.focusColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Checkout button (done, no payment yet)
              if (_booking.value.status != null &&
                  statusOrder == done &&
                  _booking.value.payment == null)
                Expanded(
                  child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Go to Checkout".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Get.theme.primaryColor, size: 22)
                      ],
                    ),
                    color: Get.theme.colorScheme.secondary,
                    onPressed: () {
                      Get.toNamed(Routes.CHECKOUT, arguments: _booking.value);
                    },
                  ),
                ),

              // Leave a review button (done + paid)
              if (_booking.value.status != null &&
                  statusOrder >= done &&
                  _booking.value.payment != null)
                Expanded(
                  child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Leave a Review".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        Icon(Icons.star_outlined,
                            color: Get.theme.primaryColor, size: 22)
                      ],
                    ),
                    color: Get.theme.colorScheme.secondary,
                    onPressed: () {
                      Get.toNamed(Routes.RATING, arguments: _booking.value);
                    },
                  ),
                ),

              SizedBox(width: 10),

              // Cancel button
              if (canCancel)
                MaterialButton(
                  onPressed: () {
                    if (isLateCancel) {
                      // 10% fee warning
                      Get.dialog(LateCancelDialog(
                        totalAmount: _booking.value.getTotal(),
                        onConfirm: () {
                          controller.cancelBookingService();
                        },
                      ));
                    } else {
                      // Free cancel
                      Get.dialog(FreeCancelDialog(
                        onPressed: () {
                          controller.cancelBookingService();
                          Get.back();
                        },
                      ));
                    }
                  },
                  padding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: isLateCancel
                      ? Colors.red.withOpacity(0.1)
                      : Get.theme.hintColor.withOpacity(0.1),
                  child: Text(
                    "Cancel".tr,
                    style: Get.textTheme.bodyText2.merge(
                      TextStyle(
                          color: isLateCancel ? Colors.red : null),
                    ),
                  ),
                  elevation: 0,
                ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        );
      }
    });
  }
}

// ─── Free Cancel Dialog ───────────────────────────────────────────────────────

class FreeCancelDialog extends StatelessWidget {
  final VoidCallback onPressed;

  const FreeCancelDialog({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Cancel Booking?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.secondary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Are you sure you want to cancel this booking? This cancellation is free of charge.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("No, Keep It"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text("Yes, Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Late Cancel Dialog (10% fee) ────────────────────────────────────────────

class LateCancelDialog extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onConfirm;

  const LateCancelDialog({Key key, this.totalAmount, this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fee = (totalAmount ?? 0) * 0.10;
    final String feeStr = fee.toStringAsFixed(2);
    final String totalStr = (totalAmount ?? 0).toStringAsFixed(2);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 22),
                SizedBox(width: 8),
                Text(
                  "Cancel Booking?",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Your provider is already on the way. Cancelling now will incur a 10% cancellation fee.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cancellation fee (10%)",
                      style: TextStyle(fontSize: 13)),
                  Text(
                    "\$$feeStr",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Order total: \$$totalStr",
              style: TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Keep Booking"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Cancel (\$$feeStr)"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
