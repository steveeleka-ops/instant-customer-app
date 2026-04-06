import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../search/controllers/search_controller.dart';
import '../../../routes/app_routes.dart';

import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          drawer: Drawer(
            child: MainDrawerWidget(),
            elevation: 0,
          ),
          body: controller.currentPage,
          bottomNavigationBar: ConvexAppBar(
            backgroundColor: Colors.white,
            //context.theme.accentColor,
            style: TabStyle.fixedCircle,
            color: Colors.orange,
            activeColor: context.theme.colorScheme.secondary,
            items: [
              TabItem(
                icon: Icons.home_outlined,
                // title: "Home".tr,
              ),
              TabItem(
                icon: Icons.assignment_outlined,
                // title: "Bookings".tr,
                // activeIcon:
              ),
              TabItem(
                icon: Icons.search,
                // title: 'Search'
              ),
              TabItem(
                icon: Icons.chat_outlined,
                // title: "Chats".tr,
              ),
              TabItem(
                icon: Icons.person_outline,
                // title: "Account".tr,
              ),
            ],
            initialActiveIndex: 2,
            //optional, default as 0
            onTap: (index) async {
              if (index != 2) {
                if (index == 3 || index == 4) {
                  controller.changePage(index - 1);
                } else {
                  controller.changePage(index);
                }
              } else {
                if (await Get.find<RootController>().isServiceAvailable()) {
                  final searchController = Get.find<SearchController>();
                  searchController.heroTag.value = UniqueKey().toString();
                  Get.toNamed(Routes.SEARCH,
                      arguments: searchController.heroTag.value);
                } else
                  Get.showSnackbar(Ui.ErrorSnackBar(message: "Unfortunately our service isn't available at your location yet. Therefore, you can not access this functionality."));
              }
            },
          )
          // FluidNavBar(
          //   style: FluidNavBarStyle(
          //     barBackgroundColor: context.theme.accentColor.withOpacity(0.4),
          //     iconBackgroundColor: context.theme.accentColor,
          //   ),
          //   // (1)
          //   icons: [
          //     FluidNavBarIcon(
          //       icon: Icons.home_outlined,
          //     ),
          //     FluidNavBarIcon(
          //       icon: Icons.assignment_outlined,
          //     ),
          //     FluidNavBarIcon(
          //       icon: Icons.chat_outlined,
          //     ),
          //     FluidNavBarIcon(
          //       icon: Icons.person_outline,
          //     ),

          //   ],
          //   onChange: (index) {
          //     controller.changePage(index);
          //   }, // (4)
          // )
          //       CustomBottomNavigationBar(

          //     backgroundColor: context.theme.scaffoldBackgroundColor,
          //     itemColor: context.theme.accentColor,
          //     currentIndex: controller.currentIndex.value,
          //     onChange: (index) {
          //       controller.changePage(index);
          //     },
          //     children: [
          // CustomBottomNavigationItem(
          //   icon: Icons.home_outlined,
          //   label: "Home".tr,
          // ),
          // CustomBottomNavigationItem(
          //   icon: Icons.assignment_outlined,
          //   label: "Bookings".tr,
          // ),
          // CustomBottomNavigationItem(
          //   icon: Icons.chat_outlined,
          //   label: "Chats".tr,
          // ),
          // CustomBottomNavigationItem(
          //   icon: Icons.person_outline,
          //   label: "Account".tr,
          // ),
          //     ],
          //   ),
          );
    });
  }
}
