import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/product_controller.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/category_screen/item_details.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';

class FeaturedCategories extends StatefulWidget {
  final String? title;
  const FeaturedCategories({super.key, required this.title});

  @override
  State<FeaturedCategories> createState() => _FeaturedCategoriesState();
}

class _FeaturedCategoriesState extends State<FeaturedCategories> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: redColor,
        title: widget.title!.text.white.fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getSubCategoryProducts(widget.title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No products found!!"),
            );
          } else {
            var data = snapshot.data!.docs;
            //items container
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 260,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          data[index]['p_imgs'][0],
                          width: 200,
                          height: 160,
                          fit: BoxFit.scaleDown,
                        ).box.roundedSM.clip(Clip.antiAlias).make(),
                        10.heightBox,
                        "${data[index]['p_name']}"
                            .text
                            .overflow(TextOverflow.ellipsis)
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
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
                        .margin(const EdgeInsets.symmetric(horizontal: 5))
                        .roundedSM
                        .outerShadow
                        .padding(const EdgeInsets.all(12))
                        .make()
                        .onTap(
                      () {
                        controller.checkIfFav(data[index]);
                        Get.to(
                          () => ItemDetails(
                            title: "${data[index]['p_name']}",
                            data: data[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
