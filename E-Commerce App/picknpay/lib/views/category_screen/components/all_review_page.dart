import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';

class AllReviewsPage extends StatelessWidget {
  final String productId;

  const AllReviewsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Rating & Reviews".text.fontFamily(semibold).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(
              future: FirestoreServices.getRatingReviews(productId: productId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: loadingIndicator(),
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Expanded(
                    child: "No reviews yet!!"
                        .text
                        .color(darkFontGrey)
                        .makeCentered(),
                  );
                } else {
                  var data = snapshot.data!.docs;

                  //items container
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                              data[index]['reviewer_name'],
                              style: const TextStyle(fontSize: 12),
                            ),
                            subtitle: Text(
                              data[index]['review'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: VxRating(
                              isSelectable: false,
                              value: double.parse(
                                  data[index]['rating'].toString()),
                              onRatingUpdate: (value) {
                                (data[index]['rating']) == value;
                              },
                              normalColor: textfieldGrey,
                              selectionColor: golden,
                              count: 5,
                              maxRating: 5,
                              size: 15,
                            ),
                          ),
                        );
                        // return Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     10.heightBox,
                        //     VxRating(
                        //       isSelectable: false,
                        //       value: double.parse(
                        //           data[index]['rating'].toString()),
                        //       onRatingUpdate: (value) {
                        //         (data[index]['rating']) == value;
                        //       },
                        //       normalColor: textfieldGrey,
                        //       selectionColor: golden,
                        //       count: 5,
                        //       maxRating: 5,
                        //       size: 25,
                        //     ),

                        //     10.heightBox,
                        //     "${data[index]['review']}"
                        //         .text
                        //         .size(16)
                        //         .fontFamily(bold)
                        //         .color(redColor)
                        //         .make(),
                        //     10.heightBox,
                        //     //"${data[index]['']}"
                        //   ],
                        // )
                        //     .box
                        //     .white
                        //     .margin(const EdgeInsets.symmetric(horizontal: 5))
                        //     .roundedSM
                        //     .outerShadow
                        //     .padding(const EdgeInsets.all(12))
                        //     .make();
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
