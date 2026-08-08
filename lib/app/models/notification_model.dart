import 'package:get/get.dart';

import 'parents/model.dart';

class Notification extends Model {
  String id;
  String type;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  Notification();

  Notification.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    type = stringFromJson(json, 'type');
    data = mapFromJson(json, 'data');
    read = boolFromJson(json, 'read_at');
    createdAt = dateFromJson(json, 'created_at',
        defaultValue: DateTime.now().toLocal());
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  String getMessage() {
    final bookingID = data['booking_id'];
    final bookingStatus = getStatus();
    if (type == 'App\\Notifications\\NewMessage') {
      return data['from'] + ' ' + type.tr;
    } else {
      var message;
      if (bookingStatus != null) message = type.tr + ' to $bookingStatus for #$bookingID';
      else message = type.tr + ' for #$bookingID';
      return message;
    }
  }

  String getStatus() {
    final statusID = data['status'];
    var status;
    switch (statusID) {
      case 2:
        status = 'In Progress';
        break;
      case 3:
        status = 'On the Way';
        break;
      case 4:
        status = 'Accepted';
        break;
      case 5:
        status = 'Ready';
        break;
      case 6:
        status = 'Done';
        break;
      case 7:
        status = 'Failed';
        break;

      default:
        status = null;
        break;
    }

    return status;
  }
}
