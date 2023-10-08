import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/product_controller.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/category_screen/components/all_review_page.dart';
import 'package:picknpay/views/category_screen/components/rating_review_page.dart';
import 'package:picknpay/views/chat_screen/chat_screen.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';
import 'package:picknpay/widgets_common/our_button.dart';

class ItemDetails extends StatefulWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, required this.data});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  var controller = Get.put(ProductController());
  @override
  void initState() {
    super.initState();
    controller.isFav.value == controller.checkIfFav(widget.data);
    widget.data['p_rating'];
    recalculateCart();
    setState(() {
      widget.data['p_rating'];
    });
  }

  recalculateCart() async {
    controller.itemsInCart.value = await controller.cartItemsLength();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: lightGrey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: widget.title!.text
                .overflow(TextOverflow.ellipsis)
                .fontFamily(bold)
                .make(),
            actions: [
              IconButton(
                onPressed: () {
                  if (controller.isFav.value) {
                    controller.removeFromWishlist(widget.data.id, context);
                  } else {
                    controller.addToWishlist(widget.data.id, context);
                  }
                },
                icon: Icon(
                  Icons.favorite_outlined,
                  color: controller.isFav.value ? darkFontGrey : whiteColor,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //swiper section
                        VxSwiper.builder(
                          autoPlay: true,
                          height: 350,
                          itemCount: widget.data['p_imgs'].length,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              widget.data['p_imgs'][index],
                              width: double.infinity,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        //title and details section
                        10.heightBox,
                        widget.title!.text
                            .overflow(TextOverflow.ellipsis)
                            .size(20)
                            .color(darkFontGrey)
                            .fontFamily(bold)
                            .make(),

                        //rating
                        10.heightBox,
                        Row(
                          children: [
                            VxRating(
                              isSelectable: false,
                              value: double.parse(
                                  widget.data['p_rating'].toString()),
                              onRatingUpdate: (value) {
                                (widget.data['p_rating']) == value;
                              },
                              normalColor: textfieldGrey,
                              selectionColor: golden,
                              count: 5,
                              maxRating: 5,
                              size: 25,
                            ),
                            "(${widget.data['p_rating']}/5.0)".text.make(),
                          ],
                        ),

                        //price
                        10.heightBox,
                        "Rs.${widget.data['p_price']}"
                            .text
                            .size(18)
                            .fontFamily(bold)
                            .color(redColor)
                            .make(),

                        10.heightBox,
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Seller"
                                      .text
                                      .size(16)
                                      .color(redColor)
                                      .fontFamily(semibold)
                                      .make(),
                                  5.heightBox,
                                  "${widget.data['p_seller']}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .size(18)
                                      .make(),
                                ],
                              ),
                            ),
                            const CircleAvatar(
                              backgroundColor: darkFontGrey,
                              child: Icon(
                                Icons.message,
                                color: whiteColor,
                              ),
                            ).onTap(
                              () {
                                Get.to(
                                  () => const ChatScreen(),
                                  arguments: [
                                    widget.data['p_seller'],
                                    widget.data['vendor_id']
                                  ],
                                );
                              },
                            ),
                          ],
                        )
                            .box
                            .height(60)
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .color(const Color.fromARGB(239, 255, 255, 255))
                            .roundedSM
                            .outerShadowSm
                            .make(),

                        10.heightBox,
                        Obx(
                          () => Column(
                            children: [
                              //quantity row
                              Row(
                                children: [
                                  "Quantity: ".text.color(darkFontGrey).make(),
                                  Obx(
                                    () => Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                                int.parse(
                                                    widget.data['p_price']));
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                        controller.quantity.value.text
                                            .color(darkFontGrey)
                                            .size(16)
                                            .fontFamily(bold)
                                            .make(),
                                        IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                              int.parse(
                                                  widget.data['p_quantity']),
                                            );
                                            controller.calculateTotalPrice(
                                                int.parse(
                                                    widget.data['p_price']));
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).box.padding(const EdgeInsets.all(8)).make(),

                              //total row
                              Row(
                                children: [
                                  "Total: ".text.color(darkFontGrey).make(),
                                  "Rs.${controller.totalPrice.value}"
                                      .text
                                      .color(redColor)
                                      .size(16)
                                      .fontFamily(bold)
                                      .make(),
                                ],
                              ).box.padding(const EdgeInsets.all(8)).make(),
                            ],
                          )
                              .box
                              .color(const Color.fromARGB(239, 255, 255, 255))
                              .shadowXs
                              .make(),
                        ),

                        //description section
                        10.heightBox,
                        "Description"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        5.heightBox,
                        Column(
                          children: [
                            "${widget.data['p_desc']}"
                                .text
                                .color(darkFontGrey)
                                .make(),
                          ],
                        )
                            .box
                            .padding(const EdgeInsets.all(8))
                            .shadowXs
                            .color(const Color.fromARGB(239, 255, 255, 255))
                            .make(),

                        10.heightBox,

                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Give your reviews"
                                      .text
                                      .fontFamily(semibold)
                                      .size(16)
                                      .make(),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ).onTap(
                                () {
                                  Get.to(() => RatingReviewPage(
                                        productid: widget.data['p_id'],
                                      ));
                                },
                              ),
                            ),
                            10.heightBox,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Rating & Reviews"
                                      .text
                                      .fontFamily(semibold)
                                      .size(16)
                                      .make(),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ).onTap(
                                () {
                                  Get.to(() => AllReviewsPage(
                                        productId: widget.data['p_id'],
                                      ));
                                },
                              ),
                            ),
                          ],
                        )
                            .box
                            .color(const Color.fromARGB(239, 255, 255, 255))
                            .make(),

                        //products you may like section
                        15.heightBox,
                        productsYouMayLike.text
                            .size(16)
                            .fontFamily(bold)
                            .color(darkFontGrey)
                            .make(),

                        10.heightBox,

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: StreamBuilder(
                            stream: FirestoreServices.getSubCategoryProducts(
                                widget.data['p_subcategory']),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: loadingIndicator(),
                                );
                              } else if (snapshot.data!.docs.isEmpty) {
                                return "No products to show"
                                    .text
                                    .color(whiteColor)
                                    .makeCentered();
                              } else {
                                var data = snapshot.data!.docs;
                                return Row(
                                  children: List.generate(
                                    data.length,
                                    (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          data[index]['p_imgs'][0],
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.contain,
                                        ),
                                        10.heightBox,
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "${data[index]['p_name']}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: semibold,
                                              color: darkFontGrey,
                                            ),
                                          ),
                                        ),
                                        10.heightBox,
                                        "Rs.${data[index]['p_price']}"
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
                                          title: "${data[index]['p_name']}",
                                          data: data[index],
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
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ourButton(
                    color: redColor,
                    onPress: () async {
                      if (controller.quantity.value > 0) {
                        controller.addToCart(
                            context: context,
                            vendorID: widget.data['vendor_id'],
                            productId: widget.data['p_id'],
                            title: widget.data['p_name'],
                            img: widget.data['p_imgs'][0],
                            qty: controller.quantity.value,
                            sellername: widget.data['p_seller'],
                            tprice: controller.totalPrice.value);
                        VxToast.show(context, msg: "Added to cart");
                        controller.itemsInCart.value =
                            await controller.cartItemsLength();
                      } else {
                        VxToast.show(context,
                            msg: "Minimum 1 product is required");
                      }
                    },
                    textColor: whiteColor,
                    title: "Add to Cart"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
