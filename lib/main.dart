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

// Collect errors during initServices for diagnostic display
final List<String> _initErrors = [];

initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  try { await Get.putAsync(() => TranslationService().init()); } catch (e) { _initErrors.add('TranslationService: $e'); Get.log('TranslationService init failed: $e'); }
  try { await Get.putAsync(() => GlobalService().init()); } catch (e) { _initErrors.add('GlobalService: $e'); Get.log('GlobalService init failed: $e'); }
  try { await Firebase.initializeApp(); } catch (e) { _initErrors.add('Firebase: $e'); Get.log('Firebase init failed: $e'); }
  try { await NotificationService().initNotification(); } catch (e) { _initErrors.add('NotificationService: $e'); Get.log('NotificationService init failed: $e'); }
  try { await Get.putAsync(() => AuthService().init()); } catch (e) { _initErrors.add('AuthService: $e'); Get.log('AuthService init failed: $e'); }
  try { await Get.putAsync(() => FireBaseMessagingService().init()); } catch (e) { _initErrors.add('FireBaseMessagingService: $e'); Get.log('FireBaseMessagingService init failed: $e'); }
  try { await Get.putAsync(() => LaravelApiClient().init()); } catch (e) { _initErrors.add('LaravelApiClient: $e'); Get.log('LaravelApiClient init failed: $e'); }
  try { await Get.putAsync(() => FirebaseProvider().init()); } catch (e) { _initErrors.add('FirebaseProvider: $e'); Get.log('FirebaseProvider init failed: $e'); }
  try { await Get.putAsync(() => SettingsService().init()); } catch (e) { _initErrors.add('SettingsService: $e'); Get.log('SettingsService init failed: $e'); }
  Get.log('All services started. Errors: ${_initErrors.length}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Override Flutter's release-mode gray error box with a visible red error
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.red.shade100,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'ERROR: ${details.exception}\n\n${details.stack}',
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ),
    );
  };

  try {
    await initServices();
  } catch (e) {
    _initErrors.add('TOP_LEVEL: $e');
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
        // Show init errors as a banner if any
        builder: _initErrors.isEmpty ? null : (context, child) {
          return Column(children: [
            Material(
              color: Colors.orange,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Init errors (${_initErrors.length}): ${_initErrors.join(' | ')}',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(child: child ?? Container()),
          ]);
        },
      ),
    ),
  );
}
