import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/views/orders_screen/components/order_place_details.dart';
import 'package:picknpay/views/orders_screen/components/order_status.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details".text.fontFamily(semibold).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                  color: redColor,
                  icon: Icons.done,
                  title: "Placed",
                  showDone: data['order_placed']),
              const Divider(
                thickness: 1.5,
              ),
              orderStatus(
                  color: Colors.blue,
                  icon: Icons.thumb_up,
                  title: "Confirmed",
                  showDone: data['order_confirmed']),
              const Divider(
                thickness: 1.5,
              ),
              orderStatus(
                  color: Colors.orange,
                  icon: Icons.car_crash,
                  title: "On Delivery",
                  showDone: data['order_on_delivery']),
              const Divider(
                thickness: 1.5,
              ),
              orderStatus(
                  color: Colors.purple,
                  icon: Icons.done_all_rounded,
                  title: "Delivered",
                  showDone: data['order_delivered']),
              const Divider(
                thickness: 1.5,
              ),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                    d1: data['order_id'],
                    d2: data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping Method",
                  ),
                  orderPlaceDetails(
                    d1: intl.DateFormat()
                        .add_yMd()
                        .format(data['order_date'].toDate()),
                    d2: data['payment_method'],
                    title1: "Order Data",
                    title2: "Payment Method",
                  ),
                  orderPlaceDetails(
                    d1: data['payment_method'] == "Khalti" ? "Paid" : "Pending",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Delivery Status",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "Name: ${data['order_by_name']}".text.make(),
                            "Email: ${data['order_by_email']}".text.make(),
                            "Address: ${data['order_by_address']}".text.make(),
                            "City: ${data['order_by_city']}".text.make(),
                            "State: ${data['order_by_state']}".text.make(),
                            "Phone: ${data['order_by_phone']}".text.make(),
                            "Postal code: ${data['order_by_postalcode']}"
                                .text
                                .make(),
                          ],
                        ),
                        Column(
                          children: [
                            "Total Amount".text.fontFamily(semibold).make(),
                            "Rs.${data['total_amount']}"
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .make()
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ).box.white.outerShadowMd.make(),
              const Divider(),
              10.heightBox,
              "Ordered Product"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .make(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                  data['orders'].length,
                  (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetails(
                          title1: data['orders'][index]['title'],
                          title2: "Rs.${data['orders'][index]['tprice']}",
                          d1: "${data['orders'][index]['qty']}x",
                          d2: "Refundable",
                        ),
                      ],
                    );
                  },
                ).toList(),
              )
                  .box
                  .outerShadowMd
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
