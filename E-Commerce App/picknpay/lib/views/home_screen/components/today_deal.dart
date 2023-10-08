import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/category_screen/item_details.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';

class TodayDeals extends StatelessWidget {
  const TodayDeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: redColor,
        title: "Today's Deals".text.white.fontFamily(semibold).make(),
      ),
      body: FutureBuilder(
        future: FirestoreServices.todaysDealsProducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No products found!"),
            );
          } else {
            var data = snapshot.data!.docs;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          data[index]['p_imgs'][0],
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        const Spacer(),
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
                        .padding(const EdgeInsets.all(12))
                        .make()
                        .onTap(
                      () {
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
