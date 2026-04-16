import 'package:flutter/material.dart';

class BookingStatusStepperWidget extends StatelessWidget {
  final int statusOrder;
  final bool isCancelled;

  const BookingStatusStepperWidget({
    Key key,
    @required this.statusOrder,
    this.isCancelled = false,
  }) : super(key: key);

  static const List<Map<String, dynamic>> _steps = [
    {'label': 'Requested', 'order': 1},
    {'label': 'Accepted', 'order': 10},
    {'label': 'On the Way', 'order': 20},
    {'label': 'In Progress', 'order': 40},
    {'label': 'Done', 'order': 50},
  ];

  Color get _activeColor {
    if (isCancelled) return Colors.red;
    if (statusOrder >= 50) return Colors.green;
    if (statusOrder >= 40) return Colors.orange;
    if (statusOrder >= 20) return Colors.purple;
    if (statusOrder >= 10) return Colors.blue;
    return Colors.amber;
  }

  bool _isStepActive(int stepOrder) {
    return !isCancelled && statusOrder >= stepOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final nextStepOrder = _steps[(i + 1) ~/ 2]['order'] as int;
              final bool lineActive = _isStepActive(nextStepOrder);
              return Expanded(
                child: Container(
                  height: 2,
                  color: lineActive ? _activeColor : Colors.grey.shade300,
                ),
              );
            } else {
              final step = _steps[i ~/ 2];
              final stepOrder = step['order'] as int;
              final bool isActive = _isStepActive(stepOrder);
              final bool isCurrent = !isCancelled && statusOrder == stepOrder;
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? _activeColor : Colors.grey.shade300,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: _activeColor.withOpacity(0.45),
                            blurRadius: 6,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
              );
            }
          }),
        ),
        SizedBox(height: 5),
        Row(
          children: _steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final stepOrder = step['order'] as int;
            final bool isActive = _isStepActive(stepOrder);
            return Expanded(
              child: Text(
                step['label'] as String,
                style: TextStyle(
                  fontSize: 7,
                  color: isActive ? _activeColor : Colors.grey.shade400,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: index == 0
                    ? TextAlign.left
                    : index == _steps.length - 1
                        ? TextAlign.right
                        : TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
