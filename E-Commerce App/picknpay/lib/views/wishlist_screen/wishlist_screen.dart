import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Wishlist".text.fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No wishlist yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: Image.network(
                        "${data[index]['p_imgs'][0]}",
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                      title: "${data[index]['p_name']}"
                          .text
                          .overflow(TextOverflow.ellipsis)
                          .size(16)
                          .fontFamily(semibold)
                          .make(),
                      subtitle: "${data[index]['p_price']}"
                          .numCurrency
                          .text
                          .color(redColor)
                          .fontFamily(semibold)
                          .make(),
                      trailing: const Icon(
                        Icons.favorite,
                        color: redColor,
                      ).onTap(
                        () async {
                          await firestore
                              .collection(productsCollection)
                              .doc(data[index].id)
                              .set(
                            {
                              'p_wishlist':
                                  FieldValue.arrayRemove([currentUser!.uid])
                            },
                            SetOptions(merge: true),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
