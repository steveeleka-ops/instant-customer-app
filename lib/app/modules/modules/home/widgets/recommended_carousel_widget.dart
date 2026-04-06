import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/category_model.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class RecommendedCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      color: Get.theme.primaryColor,
      child: Obx(() {
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.eServices.length > 0 ? controller.eServices.length+1:0,
            itemBuilder: (_, index) {
              return
                (index != controller.eServices.length)?
                GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.E_SERVICE, arguments: {'eService': controller.eServices.elementAt(index), 'heroTag': 'recommended_carousel'});
                },
                child: Container(
                  width: 180,
                  margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                  // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    //alignment: AlignmentDirectional.topStart,
                    children: [
                      Hero(
                        tag: 'recommended_carousel' + controller.eServices.elementAt(index).id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: controller.eServices.elementAt(index).firstImageUrl,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        height: 115,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              controller.eServices.elementAt(index).name ?? '',
                              maxLines: 2,
                              style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                            ),
                            Wrap(
                              children: Ui.getStarsList(controller.eServices.elementAt(index).rate),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 5,
                              alignment: WrapAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  "Start from".tr,
                                  style: Get.textTheme.caption,
                                ),
                                Ui.getPrice(
                                  controller.eServices.elementAt(index).price,
                                  style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                                  unit: controller.eServices.elementAt(index).getUnit,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ):
              InkWell(
              onTap: () {
                Category category=Category(eServices: controller.eServices,id: '',name:'',description: '',color: Colors.black,featured: false,);
                Get.toNamed(Routes.CATEGORY, arguments: category);

              },
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
              width: 70,
              alignment: Alignment.center,
              height: 70,
              margin: EdgeInsetsDirectional.only(
              end: 20, start: index == 0 ? 20 : 0),

              decoration: new BoxDecoration(
              shape: BoxShape.circle,
              gradient: new LinearGradient(
              colors: [
              Colors.orange.withOpacity(1.0),
              Colors.orange.withOpacity(0.5)
              ],
              begin: AlignmentDirectional.topStart,
              //const FractionalOffset(1, 0),
              end: AlignmentDirectional.bottomEnd,
              stops: [0.1, 0.9],
              tileMode: TileMode.clamp),
              // borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
              Image.asset(
              'assets/icon/services.png',
              fit: BoxFit.cover,
              width: 30,
              height: 30,
              )
              ],
              ),
              ),
              SizedBox(
              height: 16,
              ),
              Container(
              // height: 100,
              width: 100,
              child: Padding(
              padding:
              const EdgeInsetsDirectional.only(start: 10, top: 0),
              child: Text(
              'View All',
              maxLines: 2,
              style: Get.textTheme.bodyText2
                  .merge(TextStyle(color: Colors.black)),
              ),
              ),
              ),
              ],
              ),
              );

              ;
            });
      }),
    );
  }
}
