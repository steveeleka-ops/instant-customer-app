import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/modules/category/controllers/banner-ads-controller.dart';
import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_provider.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'app/services/notification_service.dart';

initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  try { await Get.putAsync(() => TranslationService().init()); } catch (e) { Get.log('TranslationService init failed: $e'); }
  try { await Get.putAsync(() => GlobalService().init()); } catch (e) { Get.log('GlobalService init failed: $e'); }
  try { await Firebase.initializeApp(); } catch (e) { Get.log('Firebase init failed: $e'); }
  try { await NotificationService().initNotification(); } catch (e) { Get.log('NotificationService init failed: $e'); }
  try { await Get.putAsync(() => AuthService().init()); } catch (e) { Get.log('AuthService init failed: $e'); }
  try { await Get.putAsync(() => FireBaseMessagingService().init()); } catch (e) { Get.log('FireBaseMessagingService init failed: $e'); }
  try { await Get.putAsync(() => LaravelApiClient().init()); } catch (e) { Get.log('LaravelApiClient init failed: $e'); }
  try { await Get.putAsync(() => FirebaseProvider().init()); } catch (e) { Get.log('FirebaseProvider init failed: $e'); }
  try { await Get.putAsync(() => SettingsService().init()); } catch (e) { Get.log('SettingsService init failed: $e'); }
  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initServices();
  } catch (e) {
    Get.log('initServices top-level error: $e');
  }

  final settingsService = Get.isRegistered<SettingsService>()
      ? Get.find<SettingsService>()
      : null;
  final translationService = Get.isRegistered<TranslationService>()
      ? Get.find<TranslationService>()
      : null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BannerAdsViewModel()),
      ],
      child: GetMaterialApp(
        title: settingsService?.setting?.value?.appName ?? 'Home Services',
        initialRoute: Theme1AppPages.INITIAL,
        getPages: Theme1AppPages.routes,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: translationService?.supportedLocales() ?? [const Locale('en', 'US')],
        translationsKeys: translationService?.translations ?? {},
        locale: settingsService?.getLocale() ?? const Locale('en', 'US'),
        fallbackLocale: translationService?.fallbackLocale ?? const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        themeMode: settingsService?.getThemeMode() ?? ThemeMode.light,
        theme: settingsService?.getLightTheme() ?? ThemeData.light(),
        darkTheme: settingsService?.getDarkTheme() ?? ThemeData.dark(),
      ),
    ),
  );
}
