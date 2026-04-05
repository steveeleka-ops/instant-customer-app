import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static const String LATITUDE = "Latitude";
  static const String LONGITUDE = "Longitude";
  static const String SERVICE_AVAILABLE = "service_Available";
  static const String REGION_VERIFIED = "region_verified";

  saveStringToPref(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getStringFromPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  saveBooleanToPref(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> getBooleanFromPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  saveDoubleToPref(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }

  Future<double> getDoubleFromPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }
}
