import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/orders_controller.dart';
import 'package:picknpay_seller/services/store_services.dart';
import 'package:picknpay_seller/views/orders_screen.dart/order_details.dart';
import 'package:picknpay_seller/views/widgets/appbar_widgets.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var controller = Get.put(OrdersController());

  @override
  void initState() {
    super.initState();
    getNewTotalOrders();
  }

  getNewTotalOrders() async {
    controller.newOrders.value = await controller.newTotalOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(orders),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            //print(data);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      var time = data[index]['order_date'].toDate();

                      return Card(
                        child: Badge(
                          label: const Text("New"),
                          offset: const Offset(-12, 0),
                          isLabelVisible: data[index]['order_confirmed'] ==
                                      false &&
                                  data[index]['order_on_delivery'] == false &&
                                  data[index]['order_delivered'] == false &&
                                  data[index]['order_cancelled'] == false
                              ? true
                              : false,
                          smallSize: 12,
                          child: ListTile(
                            onTap: () {
                              Get.to(() => OrderDetails(data: data[index]));
                            },
                            tileColor: lightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: boldText(
                              text: "${data[index]['order_id']}",
                              color: orange,
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    10.widthBox,
                                    normalText(
                                        text: intl.DateFormat()
                                            .add_yMd()
                                            .format(time),
                                        color: darkGrey),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.payment),
                                    10.widthBox,
                                    normalText(
                                      text:
                                          "${data[index]['payment_method']}" ==
                                                  "Khalti"
                                              ? "Paid"
                                              : "Unpaid",
                                      color: darkGrey,
                                    ),
                                    5.widthBox,
                                    normalText(
                                      text: data[index]['order_confirmed'] ==
                                              true
                                          ? "Confirmed"
                                          : data[index]['order_cancelled'] ==
                                                  true
                                              ? "Cancelled"
                                              : "",
                                      color:
                                          data[index]['order_confirmed'] == true
                                              ? Colors.green
                                              : orange,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            trailing: boldText(
                              text: "Rs ${data[index]['total_amount']}",
                              color: orange,
                              size: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
