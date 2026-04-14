import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../controllers/search_controller.dart';
import '../widgets/search_services_list_widget.dart';

class SearchView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          buildSearchBar(),
          buildSmartSuggestions(),
          SearchServicesListWidget(services: controller.eServices),
        ],
      ),
    );
  }

  Widget buildSmartSuggestions() {
    return Obx(() {
      final suggestions = controller.suggestedCategoryNames;
      if (suggestions.isEmpty) return SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Suggested categories".tr,
              style: Get.textTheme.caption.merge(
                TextStyle(color: Get.theme.hintColor, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((name) {
                return ActionChip(
                  label: Text(name, style: Get.textTheme.bodyText2),
                  backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Get.theme.colorScheme.secondary.withOpacity(0.4),
                    ),
                  ),
                  avatar: Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  onPressed: () {
                    controller.selectSuggestedCategory(name);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget buildSearchBar() {
    return Hero(
      tag: Get.arguments ?? '',
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            border: Border.all(
              color: Get.theme.focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
            ),
            Expanded(
              child: Material(
                color: Get.theme.primaryColor,
                child: TextField(
                  controller: controller.textEditingController,
                  style: Get.textTheme.bodyText2,
                  onChanged: (value) {
                    controller.onSearchTextChanged(value);
                  },
                  onSubmitted: (value) {
                    controller.searchEServices(keywords: value);
                  },
                  autofocus: true,
                  cursorColor: Get.theme.focusColor,
                  decoration: Ui.getInputDecoration(hintText: "Search for home service...".tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
