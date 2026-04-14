import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/smart_category_matcher.dart';
import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';

class SearchController extends GetxController {
  final heroTag = "".obs;
  final categories = <Category>[].obs;
  final selectedCategories = <String>[].obs;
  final suggestedCategoryNames = <String>[].obs;
  TextEditingController textEditingController;

  final eServices = <EService>[].obs;
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;

  SearchController() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    textEditingController = new TextEditingController();
  }

  @override
  void onInit() async {
    await refreshSearch();
    textEditingController.addListener(_onSearchTextChanged);
    super.onInit();
  }

  void _onSearchTextChanged() {
    final text = textEditingController.text;
    suggestedCategoryNames.assignAll(SmartCategoryMatcher.match(text));
  }

  @override
  void onClose() {
    textEditingController.removeListener(_onSearchTextChanged);
    super.onClose();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments as String;
    super.onReady();
  }

  Future refreshSearch({bool showMessage}) async {
    await getCategories();
    await searchEServices();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  Future searchEServices({String keywords}) async {
    try {
      if (selectedCategories.isEmpty) {
        eServices.assignAll(await _eServiceRepository.search(keywords, categories.map((element) => element.id).toList()));
      } else {
        eServices.assignAll(await _eServiceRepository.search(keywords, selectedCategories.toList()));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  void toggleCategory(bool value, Category category) {
    if (value) {
      selectedCategories.add(category.id);
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
    }
  }

  void selectSuggestedCategory(String categoryName) {
    Category match;
    try {
      match = categories.firstWhere(
        (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
      );
    } catch (_) {
      match = null;
    }
    if (match != null) {
      selectedCategories.assignAll([match.id]);
      searchEServices(keywords: textEditingController.text);
    }
  }
}
