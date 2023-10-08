import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/consts/lists.dart';
import 'package:picknpay/controller/home_controller.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/category_screen/item_details.dart';
import 'package:picknpay/views/home_screen/components/banner_product.dart';
import 'package:picknpay/views/home_screen/components/featured_button.dart';
import 'package:picknpay/views/home_screen/components/today_deal.dart';
import 'package:picknpay/views/home_screen/components/top_products.dart';
import 'package:picknpay/views/home_screen/search_screen.dart';
import 'package:picknpay/widgets_common/home_buttons.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(
                    Icons.search,
                    color: redColor,
                  ).onTap(
                    () {
                      if (controller
                          .searchController.text.isNotEmptyAndNotNull) {
                        Get.to(
                          () => SearchScreen(
                            title: controller.searchController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: const TextStyle(
                    color: textfieldGrey,
                  ),
                ),
              ),
            ),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //swiper brands
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: slidersList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Get.to(() =>
                                  const BannerProducts(title: "Groceries"));
                            } else if (index == 1) {
                              Get.to(() => const BannerProducts(
                                  title: "Electronic Devices"));
                            } else {
                              Get.to(() => const BannerProducts(
                                  title: "Women's Fashion"));
                            }
                          },
                          child: Image.asset(
                            slidersList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make(),
                        );
                      },
                    ),
                    15.heightBox,
                    //deals button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        2,
                        (index) => homeButtons(
                          height: context.screenHeight * 0.15,
                          width: context.screenWidth / 2.5,
                          icon: index == 0 ? icTodaysDeal : icTopProducts,
                          title: index == 0 ? todayDeal : topProducts,
                        ).onTap(() {
                          index == 0
                              ? Get.to(() => const TodayDeals())
                              : Get.to(() => const TopProducts());
                        }),
                      ),
                    ),
                    15.heightBox,
                    //another slider
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              Get.to(() => const BannerProducts(
                                  title: "Electronic Devices"));
                            } else if (index == 1) {
                              Get.to(() => const BannerProducts(
                                  title: "Women's Fashion"));
                            } else {
                              Get.to(() => const BannerProducts(
                                  title: "TV & Home Appliances"));
                            }
                          },
                          child: Image.asset(
                            secondSlidersList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make(),
                        );
                      },
                    ),
                    15.heightBox,

                    //featured categories
                    Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text
                          .size(18)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                    ),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              featuredButton(
                                icon: featuredImages1[index],
                                title: featuredTitles1[index],
                              ),
                              10.heightBox,
                              featuredButton(
                                icon: featuredImages2[index],
                                title: featuredTitles2[index],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    20.heightBox,
                    //featured products
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: redColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .size(18)
                              .fontFamily(bold)
                              .make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                              future: FirestoreServices.getFeaturedProducts(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: loadingIndicator(),
                                  );
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return "No featured products"
                                      .text
                                      .color(whiteColor)
                                      .makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;
                                  return Row(
                                    children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_imgs'][0],
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.contain,
                                          ),
                                          10.heightBox,
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              "${featuredData[index]['p_name']}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: semibold,
                                                color: darkFontGrey,
                                              ),
                                            ),
                                          ),
                                          10.heightBox,
                                          "Rs.${featuredData[index]['p_price']}"
                                              .text
                                              .size(16)
                                              .fontFamily(bold)
                                              .color(redColor)
                                              .make(),
                                        ],
                                      )
                                          .box
                                          .white
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 5))
                                          .roundedSM
                                          .padding(const EdgeInsets.all(8))
                                          .make()
                                          .onTap(() {
                                        Get.to(
                                          () => ItemDetails(
                                            title:
                                                "${featuredData[index]['p_name']}",
                                            data: featuredData[index],
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    //all products
                    20.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: allProducts.text
                          .size(18)
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .make(),
                    ),
                    15.heightBox,
                    StreamBuilder(
                      stream: FirestoreServices.allproducts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: loadingIndicator());
                        } else {
                          var allproductsdata = snapshot.data!.docs;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allproductsdata.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 300,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    allproductsdata[index]['p_imgs'][0],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.contain,
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "${allproductsdata[index]['p_name']}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: semibold,
                                        color: darkFontGrey,
                                      ),
                                    ),
                                  ),
                                  10.heightBox,
                                  "Rs.${allproductsdata[index]['p_price']}"
                                      .text
                                      .size(16)
                                      .fontFamily(bold)
                                      .color(redColor)
                                      .make(),
                                ],
                              )
                                  .box
                                  .white
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 3))
                                  .roundedSM
                                  .padding(const EdgeInsets.all(12))
                                  .make()
                                  .onTap(
                                () {
                                  Get.to(
                                    () => ItemDetails(
                                      title:
                                          "${allproductsdata[index]['p_name']}",
                                      data: allproductsdata[index],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
