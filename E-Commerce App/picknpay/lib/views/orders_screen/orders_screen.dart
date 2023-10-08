import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/orders_screen/orders_details.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No orders yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: "${index + 1}"
                      .text
                      .fontFamily(bold)
                      .color(darkFontGrey)
                      .xl
                      .make(),
                  title: data[index]['order_id']
                      .toString()
                      .text
                      .color(redColor)
                      .fontFamily(semibold)
                      .make(),
                  subtitle: "Rs.${data[index]['total_amount']}"
                      .toString()
                      .text
                      .color(darkFontGrey)
                      .fontFamily(bold)
                      .make(),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => OrdersDetails(data: data[index]));
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: darkFontGrey,
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
