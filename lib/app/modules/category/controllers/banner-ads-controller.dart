import 'package:flutter/material.dart';
import '../../../providers/ad-helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsViewModel extends ChangeNotifier {
  // COMPLETE: Add _isBannerAdReady
  var isBannerAdReady = false;

  // COMPLETE: Add _bannerAd
  BannerAd bannerAd;

  BannerAdsViewModel() {
    initBanner();
  }

  initBanner() {
    // COMPLETE: Initialize _bannerAd
    bannerAd = BannerAd(
      adUnitId: AdHelper
          .bannerAdUnitId, // "ca-app-pub-8494782412376534/4154834095",//AdHelper.bannerAdUnitId,//
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print(
              "*********************BANNER IS READY TRUE*************************");
          // setState(() {
          isBannerAdReady = true;
          print(
              "******************${isBannerAdReady}****************************");
          // update();
          // });
          notifyListeners();
        },
        onAdFailedToLoad: (ad, err) {
          print("*********************************************");
          print(
              '=============================>Failed to load a banner ad: ${err.message}');
          print("**********************************************");
          isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }
}
