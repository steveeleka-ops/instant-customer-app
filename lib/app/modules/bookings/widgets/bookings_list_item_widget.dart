/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import 'booking_status_stepper_widget.dart';

class BookingsListItemWidget extends StatelessWidget {
  const BookingsListItemWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  Color get _statusColor {
    if (_booking.cancel) return Colors.red;
    final order = _booking.status?.order ?? 0;
    if (order >= 50) return Colors.green;
    if (order >= 40) return Colors.orange;
    if (order >= 20) return Colors.purple;
    if (order >= 10) return Colors.blue;
    return Colors.amber;
  }

  String get _statusLabel {
    if (_booking.cancel) return 'Cancelled';
    return _booking.status?.status ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final int statusOrder = _booking.cancel ? -1 : (_booking.status?.order ?? 0);

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BOOKING, arguments: _booking);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: Ui.getBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: image + info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service image + date block
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        imageUrl: _booking.eService.firstImageThumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 75,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
                    ),
                    if (_booking.bookingAt != null)
                      Container(
                        width: 75,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('HH:mm', Get.locale.toString())
                                  .format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(
                                    color: Colors.white, height: 1.3),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              DateFormat('dd', Get.locale.toString())
                                  .format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.headline3.merge(
                                TextStyle(
                                    color: Colors.white, height: 1),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              DateFormat('MMM', Get.locale.toString())
                                  .format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(
                                    color: Colors.white, height: 1),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12),
                // Service info
                Expanded(
                  child: Opacity(
                    opacity: _booking.cancel ? 0.5 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _booking.eService?.name ?? '',
                                style: Get.textTheme.bodyText2,
                                maxLines: 2,
                              ),
                            ),
                            // Status badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _statusLabel,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: _statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.build_circle_outlined,
                                size: 14, color: Get.theme.focusColor),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _booking.eProvider?.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.place_outlined,
                                size: 14, color: Get.theme.focusColor),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _booking.address?.address ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Ui.getPrice(
                            _booking.getTotal(),
                            style: Get.textTheme.subtitle2
                                .merge(TextStyle(color: _statusColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Horizontal stepper
            SizedBox(height: 12),
            Divider(height: 1, thickness: 1),
            SizedBox(height: 10),
            BookingStatusStepperWidget(
              statusOrder: statusOrder,
              isCancelled: _booking.cancel,
            ),
          ],
        ),
      ),
    );
  }
}
