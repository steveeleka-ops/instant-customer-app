import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Utils {
  static const int LOCATION_SERVICE_UNAVAILABLE = 101;
  static const int LOCATION_PERMISSION_DENIED = 102;
  static const int LOCATION_PERMISSION_PERMANENTLY_DENIED = 103;

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(LOCATION_SERVICE_UNAVAILABLE);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(LOCATION_PERMISSION_DENIED);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(LOCATION_PERMISSION_PERMANENTLY_DENIED);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<void> showAlertDialog(
      BuildContext context, int errorCode) async {
    String title = "";
    String message = "";
    String btnText = "";

    if (errorCode == LOCATION_SERVICE_UNAVAILABLE) {
      title = "Location Service".tr;
      message = "Location Service is currently unavailable".tr;
      btnText = "Open Settings".tr;
    } else if (errorCode == LOCATION_PERMISSION_DENIED) {
      title = "Permission Denied".tr;
      message = "Location permission have been denied".tr;
      btnText = "Request Again".tr;
    } else if (errorCode == LOCATION_PERMISSION_PERMANENTLY_DENIED) {
      title = "Permission Denied".tr;
      message = "Location permission have been denied permanently".tr;
      btnText = "Open Settings".tr;
    }
    /*
    else {
      title = "error".tr;
      message =
          "Unfortunately, we are currently not available in your city. Therefore, you cannot access this application."
              .tr;
      btnText = "Okay".tr;
    }
*/

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Text(
            "$title",
            style: TextStyle(fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "$message",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "$btnText",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                if (errorCode == LOCATION_SERVICE_UNAVAILABLE) {
                  Geolocator.openLocationSettings();
                } else if (errorCode == LOCATION_PERMISSION_DENIED) {
                  getCurrentLocation();
                } else if (errorCode ==
                    LOCATION_PERMISSION_PERMANENTLY_DENIED) {
                  Geolocator.openAppSettings();
                } else {
                  SystemNavigator.pop();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
