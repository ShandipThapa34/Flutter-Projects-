import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/consts/lists.dart';
import 'package:picknpay/controller/cart_controller.dart';
import 'package:picknpay/services/notification_services.dart';
import 'package:picknpay/services/send_notifications.dart';
import 'package:picknpay/views/home_screen/home.dart';
import 'package:picknpay/views/payment_screen/khalti_payment_page.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';
import 'package:picknpay/widgets_common/our_button.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  var controller = Get.find<CartController>();
  NotificationServices notificationServices = NotificationServices();
  SendNotifications sendNotifications = SendNotifications();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : ourButton(
                  onPress: () async {
                    String sellerId =
                        controller.productSnapshot[0]['vendor_id'];

                    if (controller.paymentIndex.value == 0) {
                      Get.to(() => const KhaltiPaymentPage());
                    } else {
                      await controller.placeMyOrder(
                        orderPaymentMethod:
                            paymentMethods[controller.paymentIndex.value],
                        totalAmount: controller.totalP.value,
                      );
                      controller.clearCart();
                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Order placed successfully");
                      Get.offAll(const Home());
                      sendNotifications.sendNotificationToSeller(
                          sellerId: sellerId);
                    }
                  },
                  title: "Place my order",
                  color: redColor,
                  textColor: whiteColor,
                ),
        ),
        appBar: AppBar(
          title: "Choose Payment Method".text.fontFamily(semibold).make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(
                paymentMethodsImg.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changePaymentIndex(index);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.paymentIndex.value == index
                              ? Colors.green
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.asset(
                            paymentMethodsImg[index],
                            width: double.infinity,
                            height: 120,
                            colorBlendMode:
                                controller.paymentIndex.value == index
                                    ? BlendMode.darken
                                    : BlendMode.color,
                            color: controller.paymentIndex.value == index
                                ? Colors.black.withOpacity(0.4)
                                : Colors.transparent,
                            fit: BoxFit.cover,
                          ),
                          controller.paymentIndex.value == index
                              ? Transform.scale(
                                  scale: 1.3,
                                  child: Checkbox(
                                    activeColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    value: true,
                                    onChanged: (value) {},
                                  ),
                                )
                              : Container(),
                          Positioned(
                            bottom: 6,
                            left: 4,
                            child: paymentMethods[index]
                                .text
                                .white
                                .fontFamily(semibold)
                                .size(16)
                                .make(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
