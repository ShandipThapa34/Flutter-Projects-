import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/consts/lists.dart';
import 'package:picknpay/controller/cart_controller.dart';
import 'package:picknpay/services/send_notifications.dart';
import 'package:picknpay/views/home_screen/home.dart';

class KhaltiPaymentPage extends StatefulWidget {
  const KhaltiPaymentPage({super.key});

  @override
  State<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}

class _KhaltiPaymentPageState extends State<KhaltiPaymentPage> {
  TextEditingController amountController = TextEditingController();
  var controller = Get.find<CartController>();
  SendNotifications sendNotifications = SendNotifications();

  getAmt() {
    return int.parse(amountController.text) * 100; // converting to paisa
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            "Pay with Khalti",
            style: TextStyle(color: Colors.white, fontFamily: bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 15),

              //for amount
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Enter Amount To Pay",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
              ),
              const SizedBox(
                height: 12,
              ),

              //for button
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black),
                ),
                height: 50,
                color: const Color(0xFF56328c),
                child: const Text(
                  "Pay",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onPressed: () {
                  amountController.text.isEmptyOrNull
                      ? VxToast.show(context, msg: "Enter the amount")
                      : KhaltiScope.of(context).pay(
                          config: PaymentConfig(
                            amount: getAmt(),
                            productIdentity: 'dell-g5-g5510-2021',
                            productName: 'Dell G5 G5510 2021',
                          ),
                          preferences: [
                            PaymentPreference.khalti,
                          ],
                          onSuccess: (su) async {
                            String sellerId =
                                controller.productSnapshot[0]['vendor_id'];

                            await controller.placeMyOrder(
                              orderPaymentMethod:
                                  paymentMethods[controller.paymentIndex.value],
                              totalAmount: controller.totalP.value,
                            );
                            controller.clearCart();
                            Get.offAll(() => const Home());
                            const successSnackbar = SnackBar(
                                content: Text("Order Placed Successfully"));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(successSnackbar);
                            sendNotifications.sendNotificationToSeller(
                                sellerId: sellerId);
                          },
                          onFailure: (fa) {
                            const failedSnackbar =
                                SnackBar(content: Text("Payment Failed"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(failedSnackbar);
                          },
                          onCancel: () {
                            const cancelSnackbar =
                                SnackBar(content: Text("Payment Cancelled"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(cancelSnackbar);
                          },
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
