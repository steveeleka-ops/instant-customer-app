import 'parents/model.dart';

class Setting extends Model {
  late String appName;
  late bool enableStripe;
  late String defaultTax;
  late String defaultCurrency;
  late String fcmKey;
  late bool enablePaypal;
  late String defaultTheme;
  late String mainColor;
  late String mainDarkColor;
  late String secondColor;
  late String secondDarkColor;
  late String accentColor;
  late String accentDarkColor;
  late String scaffoldDarkColor;
  late String scaffoldColor;
  late String googleMapsKey;
  late String mobileLanguage;
  late String appVersion;
  late bool enableVersion;
  late bool currencyRight;
  late int defaultCurrencyDecimalDigits;
  late bool enableRazorpay;
  late String homeSection1;
  late String homeSection2;
  late String homeSection3;
  late String homeSection4;
  late String homeSection5;
  late String homeSection6;
  late String homeSection7;
  late String homeSection8;
  late String homeSection9;
  late String homeSection10;
  late String homeSection11;
  late String homeSection12;

  Setting(
      {this.appName,
      this.enableStripe,
      this.defaultTax,
      this.defaultCurrency,
      this.fcmKey,
      this.enablePaypal,
      this.mainColor,
      this.mainDarkColor,
      this.secondColor,
      this.secondDarkColor,
      this.accentColor,
      this.accentDarkColor,
      this.scaffoldDarkColor,
      this.scaffoldColor,
      this.googleMapsKey,
      this.mobileLanguage,
      this.appVersion,
      this.enableVersion,
      this.currencyRight,
      this.defaultCurrencyDecimalDigits,
      this.enableRazorpay,
      this.homeSection1,
      this.homeSection2,
      this.homeSection3,
      this.homeSection4,
      this.homeSection5,
      this.homeSection6,
      this.homeSection7,
      this.homeSection8,
      this.homeSection9,
      this.homeSection10,
      this.homeSection11,
      this.homeSection12});

  Setting.fromJson(Map<String, dynamic> json) {
    appName =  "Instant";// 'Wapp'; //'HostShot Services'; //'Headhunt';// json['app_name'];
    defaultTax = json['default_tax'];
    defaultCurrency = "\$"; //"MYR"; //json['default_currency'];
    fcmKey = json['fcm_key'];
    defaultTheme = json['default_theme'];
    mainColor = json['main_color'];
    mainDarkColor = json['main_dark_color'];
    secondColor = json['second_color'];
    secondDarkColor = json['second_dark_color'];
    accentColor = json['accent_color'];
    accentDarkColor = json['accent_dark_color'];
    scaffoldDarkColor = json['scaffold_dark_color'];
    scaffoldColor = json['scaffold_color'];
    googleMapsKey = json['google_maps_key'];
    mobileLanguage = json['mobile_language'];
    appVersion = json['app_version'];
    enableVersion = boolFromJson(json, 'enable_version');
    currencyRight = boolFromJson(json, 'currency_right');
    enableRazorpay = boolFromJson(json, 'enable_razorpay');
    enableStripe = true;
    boolFromJson(json, 'enable_stripe');
    enablePaypal = boolFromJson(json, 'enable_paypal');
    defaultCurrencyDecimalDigits =
        int.tryParse((json['default_currency_decimal_digits'] ?? '2').toString()) ?? 2;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['enable_stripe'] = this.enableStripe;
    data['default_tax'] = this.defaultTax;
    data['default_currency'] = this.defaultCurrency;
    data['fcm_key'] = this.fcmKey;
    data['enable_paypal'] = this.enablePaypal;
    data['main_color'] = this.mainColor;
    data['default_theme'] = this.defaultTheme;
    data['main_dark_color'] = this.mainDarkColor;
    data['second_color'] = this.secondColor;
    data['second_dark_color'] = this.secondDarkColor;
    data['accent_color'] = this.accentColor;
    data['accent_dark_color'] = this.accentDarkColor;
    data['scaffold_dark_color'] = this.scaffoldDarkColor;
    data['scaffold_color'] = this.scaffoldColor;
    data['google_maps_key'] = this.googleMapsKey;
    data['mobile_language'] = this.mobileLanguage;
    data['app_version'] = this.appVersion;
    data['enable_version'] = this.enableVersion;
    data['currency_right'] = this.currencyRight;
    data['default_currency_decimal_digits'] = this.defaultCurrencyDecimalDigits;
    data['enable_razorpay'] = this.enableRazorpay;
    return data;
  }
}
