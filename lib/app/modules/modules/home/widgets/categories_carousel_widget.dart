import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(bottom: 15),
      child: Obx(() {
        return ListView.builder(
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length>0 ?  controller.categories.length + 1:0,
            itemBuilder: (_, index) {

              return
                (index != controller.categories.length)?

                InkWell(
                onTap: () {
                  Get.toNamed(Routes.CATEGORY, arguments: controller.categories.elementAt(index));
                },
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsetsDirectional.only(
                          end: 20, start: index == 0 ? 20 : 0),

                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: new LinearGradient(
                            colors: [
                              controller.categories.elementAt(index).color.withOpacity(1),
                              controller.categories.elementAt(index).color.withOpacity(0.1)
                            ],
                            begin: AlignmentDirectional.topStart,
                            //const FractionalOffset(1, 0),
                            end: AlignmentDirectional.bottomEnd,
                            stops: [0.1, 0.9],
                            tileMode: TileMode.clamp),
                        // borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [

                          (controller.categories.elementAt(index).image.url
                                      .toLowerCase()
                                      .endsWith('.svg')
                                  ? SvgPicture.network(controller.categories.elementAt(index).image.url,
                                      color: controller.categories.elementAt(index).color,
                                      fit: BoxFit.contain)
                                  : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                      imageUrl: controller.categories.elementAt(index).image.url,
                                      placeholder: (context, url) =>
                                          Container(
                                                  width: 100,
                                              height: 100,


                                                  child:  Image.asset(
                                                    'assets/img/loading.gif',
                                                    fit: BoxFit.cover,
                                                  )
                                          )
                                        ,
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              width: 100,
                                              height: 100,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child:   Icon(Icons.error_outline),
                                          )

                                    )),


                          // Padding(
                          //   padding:
                          //       const EdgeInsetsDirectional.only(start: 10, top: 0),
                          //   child: Text(
                          //     _category.name,
                          //     maxLines: 2,
                          //     style: Get.textTheme.bodyText2
                          //         .merge(TextStyle(color: Get.theme.primaryColor)),
                          //   ),
                          // ),
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
                          controller.categories.elementAt(index).name,
                          maxLines: 2,
                          style: Get.textTheme.bodyText2
                              .merge(TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ) :

                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CATEGORIES);
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
                              'assets/icon/category.png',
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
                            'View All\nCategories',
                            maxLines: 2,
                            style: Get.textTheme.bodyText2
                                .merge(TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ;
              }
            );
      }),
    );
  }
}
