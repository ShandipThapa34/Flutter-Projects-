import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/cart_controller.dart';
import 'package:picknpay/views/cart_screen/payment_method.dart';
import 'package:picknpay/widgets_common/custom_textfield.dart';
import 'package:picknpay/widgets_common/our_button.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(semibold).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.isEmptyOrNull &&
                controller.cityController.text.isEmptyOrNull &&
                controller.stateController.text.isEmptyOrNull &&
                controller.postalcodeController.text.isEmptyOrNull &&
                controller.phoneController.text.isEmptyOrNull) {
              VxToast.show(context, msg: "Please fill all the form");
            } else {
              Get.to(() => const PaymentMethods());
            }
          },
          title: "Continue",
          color: redColor,
          textColor: whiteColor,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              customTextField(
                hint: "Address",
                isPass: false,
                title: "Address",
                controller: controller.addressController,
              ),
              customTextField(
                hint: "City",
                isPass: false,
                title: "City",
                controller: controller.cityController,
              ),
              customTextField(
                hint: "State",
                isPass: false,
                title: "State",
                controller: controller.stateController,
              ),
              customTextField(
                hint: "Postal Code",
                isPass: false,
                title: "Postal Code",
                controller: controller.postalcodeController,
                keyboardType: TextInputType.number,
              ),
              customTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
