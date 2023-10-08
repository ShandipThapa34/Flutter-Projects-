import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/orders_controller.dart';
import 'package:picknpay_seller/services/send_notifications.dart';
import 'package:picknpay_seller/views/orders_screen.dart/components/order_place.dart';
import 'package:picknpay_seller/views/widgets/our_button.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;

  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();
  SendNotifications sendNotifications = SendNotifications();

  @override
  void initState() {
    super.initState();

    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
    controller.cancelled.value = widget.data['order_cancelled'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: boldText(text: "Order Details", color: fontGrey, size: 16.0),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value && !controller.cancelled.value,
          // child: SizedBox(
          //   height: 60,
          //   width: context.screenWidth,
          //   child: ourButton(
          //     color: green,
          //     onPress: () {
          //       controller.confirmed(true);
          //       controller.changeStatus(
          //         title: "order_confirmed",
          //         status: true,
          //         docID: widget.data.id,
          //       );
          //     },
          //     title: "Confirm Order",
          //   ),
          // ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 60,
                  width: context.screenWidth * 0.45,
                  child: ourButton(
                      color: orange,
                      onPress: () {
                        controller.cancelled(true);
                        controller.changeStatus(
                          title: "order_cancelled",
                          status: true,
                          docID: widget.data.id,
                        );
                        sendNotifications.sendNotificationToBuyer(
                          buyerId: widget.data['order_by'],
                          title: "Order Cancelled",
                          body:
                              "Your order has been cancelled, We are really sorry for your inconvenience.",
                        );
                      },
                      title: "Cancel"),
                ),
                5.widthBox,
                SizedBox(
                  height: 60,
                  width: context.screenWidth * 0.45,
                  child: ourButton(
                      color: green,
                      onPress: () {
                        controller.confirmed(true);
                        controller.changeStatus(
                          title: "order_confirmed",
                          status: true,
                          docID: widget.data.id,
                        );
                        sendNotifications.sendNotificationToBuyer(
                          buyerId: widget.data['order_by'],
                          title: "Order Confirmation",
                          body:
                              "Your Order is confirmed and on its way to delivery",
                        );
                      },
                      title: "Confirm"),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //order delivery status section
                Visibility(
                    visible: controller.confirmed.value ||
                        controller.cancelled.value,
                    child: controller.confirmed.value
                        ? Column(
                            children: [
                              10.heightBox,
                              boldText(
                                  text: "Order Status",
                                  color: fontGrey,
                                  size: 16.0),
                              SwitchListTile(
                                activeColor: green,
                                value: true,
                                onChanged: (value) {},
                                title:
                                    boldText(text: "Placed", color: fontGrey),
                              ),
                              SwitchListTile(
                                activeColor: green,
                                value: controller.confirmed.value,
                                onChanged: (value) {},
                                title: boldText(
                                    text: "Confirmed", color: fontGrey),
                              ),
                              SwitchListTile(
                                activeColor: green,
                                value: controller.ondelivery.value,
                                onChanged: (value) {
                                  controller.ondelivery.value = value;
                                  controller.changeStatus(
                                    title: "order_on_delivery",
                                    status: value,
                                    docID: widget.data.id,
                                  );
                                },
                                title: boldText(
                                    text: "On Delivery", color: fontGrey),
                              ),
                              SwitchListTile(
                                activeColor: green,
                                value: controller.delivered.value,
                                onChanged: (value) {
                                  controller.delivered.value = value;
                                  controller.changeStatus(
                                    title: "order_delivered",
                                    status: value,
                                    docID: widget.data.id,
                                  );
                                },
                                title: boldText(
                                    text: "Delivered", color: fontGrey),
                              ),
                            ],
                          )
                            .box
                            .white
                            .outerShadowMd
                            .border(color: lightGrey)
                            .roundedSM
                            .make()
                        : Column(
                            children: [
                              10.heightBox,
                              boldText(
                                  text: "Order Status",
                                  color: fontGrey,
                                  size: 16.0),
                              SwitchListTile(
                                activeColor: orange,
                                value: controller.cancelled.value,
                                onChanged: (value) {},
                                title: boldText(
                                    text: "Cancelled", color: fontGrey),
                              ),
                            ],
                          )
                            .box
                            .white
                            .outerShadowMd
                            .border(color: lightGrey)
                            .roundedSM
                            .make()),
                10.heightBox,
                //order details section
                Column(
                  children: [
                    orderPlaceDetails(
                      d1: "${widget.data['order_id']}",
                      d2: "${widget.data['shipping_method']}",
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    orderPlaceDetails(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format(widget.data['order_date'].toDate()),
                      d2: "${widget.data['payment_method']}",
                      title1: "Order Data",
                      title2: "Payment Method",
                    ),
                    orderPlaceDetails(
                      d1: widget.data['payment_method'] == "Khalti"
                          ? "Paid"
                          : "Unpaid",
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
                          SizedBox(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //"Shipping Address".text.fontFamily(semibold).make(),
                                boldText(
                                    text: "Shipping Address", color: fontGrey),
                                "Name: ${widget.data['order_by_name']}"
                                    .text
                                    .make(),
                                "Email: ${widget.data['order_by_email']}"
                                    .text
                                    .make(),
                                "Address: ${widget.data['order_by_address']}"
                                    .text
                                    .make(),
                                "City: ${widget.data['order_by_city']}"
                                    .text
                                    .make(),
                                "State: ${widget.data['order_by_state']}"
                                    .text
                                    .make(),
                                "Phone: ${widget.data['order_by_phone']}"
                                    .text
                                    .make(),
                                "Postal code: ${widget.data['order_by_postalcode']}"
                                    .text
                                    .make(),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(text: "Total Amount", color: fontGrey),
                                boldText(
                                    text: "Rs ${widget.data['total_amount']}",
                                    color: orange,
                                    size: 16.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
                    .box
                    .white
                    .outerShadowMd
                    .border(color: lightGrey)
                    .roundedSM
                    .make(),
                const Divider(),
                10.heightBox,
                boldText(text: "Ordered Products", color: fontGrey, size: 16.0),
                10.heightBox,
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                    controller.orders.length,
                    (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          orderPlaceDetails(
                            title1: "${controller.orders[index]['title']}",
                            title2: "Rs.${controller.orders[index]['tprice']}",
                            d1: "${controller.orders[index]['qty']}x",
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
      ),
    );
  }
}
