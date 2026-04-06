import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_services/app/models/category_model.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          await controller.refreshHome(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: CustomScrollView(
          primary: true,
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 300,
                elevation: 0.5,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
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
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: controller.slider.isEmpty
                          ? AlignmentDirectional.center
                          : Ui.getAlignmentDirectional(controller.slider
                              .elementAt(controller.currentSlide.value)
                              .textPosition),
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 360,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((Slide slide) {
                            return SlideItemWidget(slide: slide);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((Slide slide) {
                              return Container(
                                width: 20.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value ==
                                            controller.slider.indexOf(slide)
                                        ? slide.indicatorColor
                                        : slide.indicatorColor
                                            .withOpacity(0.4)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ).marginOnly(bottom: 42)),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  AddressWidget(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text("Categories".tr,
                                style: Get.textTheme.headline5)),
                        MaterialButton(
                          onPressed: () {
                            Get.toNamed(Routes.CATEGORIES);
                          },
                          shape: StadiumBorder(),
                          color:
                              Get.theme.colorScheme.secondary.withOpacity(0.1),
                          child: Text("View All".tr,
                              style: Get.textTheme.subtitle1),
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                  CategoriesCarouselWidget(),
                  Container(
                    color: Get.theme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text("Instant Booking".tr,
                                style: Get.textTheme.headline5)),
                        MaterialButton(
                          onPressed: () {
                            Category category = Category(
                              eServices: controller.eServices,
                              id: '',
                              name: '',
                              description: '',
                              color: Colors.black,
                              featured: false,
                            );
                            Get.toNamed(Routes.CATEGORY, arguments: category);
                            // Get.toNamed(Routes.CATEGORIES);
                          },
                          shape: StadiumBorder(),
                          color:
                              Get.theme.colorScheme.secondary.withOpacity(0.1),
                          child: Text("View All".tr,
                              style: Get.textTheme.subtitle1),
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                  RecommendedCarouselWidget(),
                ],
              ),
            )
/*            else if (controller.hasLocationService.isTrue &&
                controller.hasLocationPermission.isTrue)
              SliverToBoxAdapter(
                  child: Container(
                      height: 600,
                      alignment: Alignment.center,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Hi, nice to meet you",
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyLarge.merge(TextStyle(
                                    color: Colors.grey, fontSize: 18)),
                              ),
                              Text(
                                "See Service Availability",
                                textAlign: TextAlign.center,
                                style: Get.textTheme.headline6.merge(TextStyle(
                                    color: Get.theme.colorScheme.primary,
                                    fontSize: 24)),
                              ).paddingSymmetric(vertical: 10, horizontal: 20),
                              Image.asset(
                                'assets/icon/ic_city.png',
                                fit: BoxFit.cover,
                              ).paddingOnly(left: 30, right: 30, top: 30),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // Adjust the radius as needed
                                  color: Get.theme.colorScheme
                                      .secondary, // Button color
                                ),
                                child: MaterialButton(
                                  onPressed: () {},
                                  height: 44,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          Colors.white,
                                          // Change this color to the desired tint color
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'assets/icon/ic_current_location.png',
                                          fit: BoxFit.cover,
                                          height: 24,
                                          width: 24,
                                        ).paddingOnly(right: 20),
                                      ),
                                      Text(
                                        "Your Current Location".tr,
                                        style: Get.textTheme.headline6.merge(
                                            TextStyle(
                                                color: Get.theme.primaryColor)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Get.theme.colorScheme.secondary,
                                        width: 2.0)),
                                child: MaterialButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.SETTINGS_ADDRESSES);
                                  },
                                  height: 44,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          Get.theme.colorScheme.secondary,
                                          // Change this color to the desired tint color
                                          BlendMode.srcIn,
                                        ),
                                        child: Icon(Icons.search,
                                                color: Get.theme.colorScheme
                                                    .secondary)
                                            .paddingOnly(right: 20),
                                      ),
                                      Text(
                                        "Choose from Address".tr,
                                        style: Get.textTheme.headline6.merge(
                                            TextStyle(
                                                color: Get.theme.colorScheme
                                                    .secondary)),
                                      )
                                    ],
                                  ),
                                ),
                              ).paddingOnly(top: 20),
                            ]),
                      )))
            else
              SliverToBoxAdapter(
                child: Container(
                    height: 600,
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon/ic_location_icon.png',
                              fit: BoxFit.cover,
                              height: 150,
                              width: 150,
                            ).paddingOnly(bottom: 30),
                            Text(
                              controller.hasLocationService.isTrue
                                  ? controller.hasLocationPermission.isTrue
                                      ? null
                                      : "Provide the location permissions in order to proceed."
                                  : "Location services are currently disabled.",
                              style: Get.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ).paddingSymmetric(horizontal: 30),
                            SizedBox(height: 10),
                            MaterialButton(
                              onPressed: () {
                                if (!controller.hasLocationService.value)
                                  Geolocator.openLocationSettings();
                                else if (!controller
                                    .permissionPermanentlyRejected.value)
                                  Geolocator.openAppSettings();
                                // else controller.getCurrentLocation();
                              },
                              shape: StadiumBorder(),
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(0.1),
                              child: Text(
                                  controller.hasLocationService.isTrue
                                      ? controller.hasLocationPermission.isTrue
                                          ? null
                                          : "Provide Location Permission"
                                      : "Enable Location Service",
                                  style: Get.textTheme.subtitle1),
                              elevation: 0,
                            )
                          ]),
                    )),
              ),*/
          ],
        ),
      );
    }));
  }
}
