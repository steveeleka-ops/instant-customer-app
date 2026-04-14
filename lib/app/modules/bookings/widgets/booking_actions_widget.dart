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
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (_booking.value.status != null &&
                _booking.value.status.order ==
                    Get.find<GlobalService>().global.value.done &&
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
                    }),
              ),

            if (_booking.value.status != null &&
                _booking.value.status.order >=
                    Get.find<GlobalService>().global.value.done &&
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
                    }),
              ),
            SizedBox(width: 10),
            if (!_booking.value.cancel &&
                _booking.value.status != null &&
                _booking.value.status.order <
                    Get.find<GlobalService>().global.value.onTheWay)
              MaterialButton(
                onPressed: () {
                  // controller.cancelBookingService();
                  Get.dialog(CancelDialog(
                    onPressed: () {
                      controller.cancelBookingService();
                      Get.back();
                    },
                  ));
                },
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Get.theme.hintColor.withOpacity(0.1),
                child: Text("Cancel".tr, style: Get.textTheme.bodyText2),
                elevation: 0,
              ),
          ]).paddingSymmetric(vertical: 10, horizontal: 20),
        );
      }
    });
  }
}

class CancelDialog extends StatefulWidget {
  final onPressed;
  CancelDialog({this.onPressed});
  // const CancelDialog({ Key? key }) : super(key: key);

  @override
  State<CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<CancelDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 20, top: 18, left: 10, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Confirm ",
                  style: TextStyle(
                    fontSize: 19,
                    color: context.theme.colorScheme.secondary,
                  )),
              // SizedBox(height: 28),
              Text(
                "Are you sure you want to cancel the booking ?.By cancelling you will be charged if a cancellation is made one hour before the start time.",
                style: TextStyle(
                    fontFamily: '',
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("NO")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: widget.onPressed, child: Text("YES"))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
