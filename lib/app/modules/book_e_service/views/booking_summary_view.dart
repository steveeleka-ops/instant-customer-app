import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/book_e_service_controller.dart';
import '../widgets/payment_details_widget.dart';

class BookingSummaryView extends GetView<BookEServiceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Booking Summary".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBottomWidget(context, controller.booking.value),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Booking At".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  (!controller.booking.value.isBlank) ?
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${DateFormat.yMMMMEEEEd(Get.locale.toString()).format(controller.booking.value.bookingAt)}', style: Get.textTheme.bodyText2),
                              Text('${DateFormat('HH:mm', Get.locale.toString()).format(controller.booking.value.bookingAt)}', style: Get.textTheme.bodyText2),
                            ],
                          )),
                    ],
                  ):Container(),

                ],
              ),
            ),
            Obx(() {
              final rec = controller.recurrence.value;
              if (rec.isEmpty) return SizedBox.shrink();
              final label = rec[0].toUpperCase() + rec.substring(1);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: Ui.getBoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recurrent Booking".tr, style: Get.textTheme.bodyText1),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.repeat, color: Colors.blue),
                        SizedBox(width: 15),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(label, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Next booking auto-created after job completion.".tr,
                            style: Get.textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Address".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (controller.currentAddress.hasDescription()) Text(controller.currentAddress?.getDescription ?? "Loading...".tr, style: Get.textTheme.subtitle2),
                              if (controller.currentAddress.hasDescription()) SizedBox(height: 10),
                              Text(controller.currentAddress?.address ?? "Loading...".tr, style: Get.textTheme.bodyText2),
                            ],
                          );
                        }),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("A Hint for the Provider".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.description_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Text(controller.booking.value.hint ?? "".tr, style: Get.textTheme.bodyText2);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildBottomWidget(BuildContext context, Booking _booking) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20 + bottomPadding),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentDetailsWidget(booking: _booking),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock_outline, size: 13, color: Get.theme.hintColor),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Your payment will be held securely until the job is completed and approved by you.".tr,
                        style: Get.textTheme.caption.merge(TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.credit_card_outlined, size: 13, color: Get.theme.hintColor),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Your card will be saved to maintain the hold if the job requires additional work.".tr,
                        style: Get.textTheme.caption.merge(TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Confirm & Booking Now".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
                ],
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () {
                controller.createBooking();
              }).paddingSymmetric(vertical: 10, horizontal: 20),
        ],
      ),
    );
  }
}
