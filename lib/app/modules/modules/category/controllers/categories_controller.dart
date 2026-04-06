import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../repositories/category_repository.dart';


enum CategoriesLayout { GRID, LIST }

class CategoriesController extends GetxController {
  CategoryRepository _categoryRepository;

  final categories = <Category>[].obs;
  final layout = CategoriesLayout.GRID.obs;
  // COMPLETE: Add _isBannerAdReady
  // var isBannerAdReady = false.obs;

  // COMPLETE: Add _bannerAd
  // BannerAd bannerAd;
  CategoriesController() {
    _categoryRepository = new CategoryRepository();
  }

  @override
  Future<void> onInit() async {

    // initBanner();
    await refreshCategories();
    super.onInit();
  }
  // @override
  // void onReady() { // called after the widget is rendered on screen
  //
  //   super.onReady();
  // }
  // initBanner() {
  //   // COMPLETE: Initialize _bannerAd
  //   bannerAd = BannerAd(
  //     adUnitId:AdHelper.bannerAdUnitId,// "ca-app-pub-8494782412376534/4154834095",//AdHelper.bannerAdUnitId,//
  //     request: AdRequest(),
  //     size: AdSize.banner,
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //
  //         print("*********************BANNER IS READY TRUE*************************");
  //         // setState(() {
  //         isBannerAdReady = true.obs;
  //         print("******************${isBannerAdReady.isTrue}****************************");
  //         // update();
  //         // });
  //       },
  //       onAdFailedToLoad: (ad, err) {
  //         print("*********************************************");
  //         print('=============================>Failed to load a banner ad: ${err.message}');
  //         print("**********************************************");
  //         isBannerAdReady = false.obs;
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //
  //   bannerAd.load();
  // }

  Future refreshCategories({bool showMessage}) async {
    await getCategories();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of categories refreshed successfully".tr));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllWithSubCategories());

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
