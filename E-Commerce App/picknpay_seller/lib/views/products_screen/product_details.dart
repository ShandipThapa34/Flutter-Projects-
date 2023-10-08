import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;

  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: boldText(text: "${data['p_name']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
              autoPlay: true,
              height: 350,
              itemCount: data['p_imgs'].length,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              itemBuilder: (context, index) {
                return Image.network(
                  data['p_imgs'][index],
                  width: double.infinity,
                  fit: BoxFit.contain,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.heightBox,
                  boldText(
                      text: "${data['p_name']}", color: fontGrey, size: 18.0),

                  const Divider(),
                  Row(
                    children: [
                      boldText(
                          text: "${data['p_category']}",
                          color: fontGrey,
                          size: 16.0),
                      10.widthBox,
                      normalText(
                          text: "${data['p_subcategory']}",
                          color: fontGrey,
                          size: 16.0),
                    ],
                  ),

                  //rating
                  10.heightBox,
                  VxRating(
                    isSelectable: false,
                    value: double.parse((data['p_rating']).toString()),
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    maxRating: 5,
                    size: 25,
                  ),

                  //price
                  10.heightBox,
                  boldText(
                      text: "Rs. ${data['p_price']}",
                      color: orange,
                      size: 18.0),

                  10.heightBox,
                  const Divider(
                    thickness: 2.0,
                  ),
                  10.heightBox,
                  Column(
                    children: [
                      //quantity row
                      Row(
                        children: [
                          SizedBox(
                            child:
                                boldText(text: "Quantity: ", color: fontGrey),
                          ),
                          normalText(
                              text: "${data['p_quantity']} items",
                              color: fontGrey),
                        ],
                      ),
                    ],
                  ),
                  10.heightBox,
                  const Divider(
                    thickness: 2.0,
                  ),
                  //description section
                  10.heightBox,
                  boldText(text: "Description: ", color: fontGrey),
                  10.heightBox,
                  Column(
                    children: [
                      normalText(text: "${data['p_desc']}", color: fontGrey),
                    ],
                  ),
                ],
              ).box.white.padding(const EdgeInsets.all(8)).shadowSm.make(),
            ),
          ],
        ),
      ),
    );
  }
}
