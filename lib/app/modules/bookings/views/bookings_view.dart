import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/bookings_list_widget.dart';

class BookingsView extends GetView<BookingsController> {
  @override
  Widget build(BuildContext context) {
    controller.initScrollController();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          await controller.refreshBookings(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: 70,
              elevation: 0.5,
              floating: false,
              iconTheme: IconThemeData(color: Get.theme.primaryColor),
              title: Text(
                Get.find<SettingsService>().setting.value.appName,
                style: Get.textTheme.headline6,
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(Icons.sort, color: Colors.black87),
                onPressed: () => {Scaffold.of(context).openDrawer()},
              ),
              actions: [NotificationsButtonWidget()],
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  BookingsListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
