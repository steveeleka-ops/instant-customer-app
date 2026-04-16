import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/booking_model.dart';

class BookingStatusTimelineWidget extends StatelessWidget {
  final Booking booking;

  const BookingStatusTimelineWidget({
    Key key,
    @required this.booking,
  }) : super(key: key);

  static const List<Map<String, dynamic>> _steps = [
    {
      'label': 'Requested',
      'order': 1,
      'icon': Icons.assignment_outlined,
      'description': 'Your booking was submitted',
    },
    {
      'label': 'Accepted',
      'order': 10,
      'icon': Icons.check_circle_outline,
      'description': 'Provider confirmed your booking',
    },
    {
      'label': 'On the Way',
      'order': 20,
      'icon': Icons.directions_car_outlined,
      'description': 'Your provider is heading to you',
    },
    {
      'label': 'In Progress',
      'order': 40,
      'icon': Icons.build_outlined,
      'description': 'Service is in progress',
    },
    {
      'label': 'Done',
      'order': 50,
      'icon': Icons.done_all,
      'description': 'Service completed successfully',
    },
  ];

  Color get _currentColor {
    if (booking.cancel) return Colors.red;
    final order = booking.status?.order ?? 0;
    if (order >= 50) return Colors.green;
    if (order >= 40) return Colors.orange;
    if (order >= 20) return Colors.purple;
    if (order >= 10) return Colors.blue;
    return Colors.amber;
  }

  Color _getStepColor(int stepOrder) {
    if (booking.cancel) return Colors.grey;
    final currentOrder = booking.status?.order ?? 0;
    if (currentOrder < stepOrder) return Colors.grey.shade300;
    if (currentOrder >= 50) return Colors.green;
    if (currentOrder >= 40) return Colors.orange;
    if (currentOrder >= 20) return Colors.purple;
    if (currentOrder >= 10) return Colors.blue;
    return Colors.amber;
  }

  String _getTimestamp(int stepOrder) {
    try {
      if (stepOrder == 1 && booking.created_at != null) {
        return DateFormat("MMM d 'at' HH:mm").format(booking.created_at);
      }
      if (stepOrder == 40 && booking.startAt != null) {
        return DateFormat("MMM d 'at' HH:mm").format(booking.startAt);
      }
      if (stepOrder == 50 && booking.endsAt != null) {
        return DateFormat("MMM d 'at' HH:mm").format(booking.endsAt);
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentOrder = booking.cancel ? -1 : (booking.status?.order ?? 0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Order Status".tr, style: Get.textTheme.subtitle2),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _currentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.cancel
                      ? "Cancelled".tr
                      : (booking.status?.status ?? ''),
                  style: TextStyle(
                    color: _currentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ..._buildSteps(currentOrder),
        ],
      ),
    );
  }

  List<Widget> _buildSteps(int currentOrder) {
    List<Widget> widgets = [];
    for (int i = 0; i < _steps.length; i++) {
      final step = _steps[i];
      final stepOrder = step['order'] as int;
      final bool isCompleted = !booking.cancel && currentOrder >= stepOrder;
      final bool isCurrent = !booking.cancel && currentOrder == stepOrder;
      final bool isLast = i == _steps.length - 1;
      final Color stepColor = _getStepColor(stepOrder);
      final String timestamp = _getTimestamp(stepOrder);

      widgets.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + vertical line
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? stepColor : Colors.grey.shade100,
                      border: Border.all(
                        color: isCompleted ? stepColor : Colors.grey.shade300,
                        width: isCurrent ? 2.5 : 1.5,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: stepColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      step['icon'] as IconData,
                      size: 14,
                      color: isCompleted ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: (isCompleted && currentOrder > stepOrder)
                            ? stepColor.withOpacity(0.4)
                            : Colors.grey.shade200,
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),
              // Text content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isCompleted ? FontWeight.w600 : FontWeight.normal,
                          color: isCompleted ? stepColor : Colors.grey.shade400,
                        ),
                      ),
                      if (isCompleted || isCurrent) ...[
                        SizedBox(height: 2),
                        Text(
                          step['description'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        if (timestamp != null) ...[
                          SizedBox(height: 2),
                          Text(
                            timestamp,
                            style: TextStyle(
                              fontSize: 10,
                              color: stepColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}
