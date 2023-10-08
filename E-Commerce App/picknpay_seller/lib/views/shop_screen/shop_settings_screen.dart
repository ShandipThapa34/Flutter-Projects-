import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/profile_controller.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: boldText(text: shopSettings, color: fontGrey, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator()
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      // print("shop details");
                      // print(controller.shopNameController.text);
                      // print(controller.shopAddressController.text);
                      // print(controller.shopMobileController.text);
                      // print(controller.shopWebsiteController.text);
                      // print(controller.shopDescController.text);
                      await controller.updateShop(
                        shopaddress:
                            controller.shopAddressController.text.trim(),
                        shopname: controller.shopNameController.text.trim(),
                        shopmobile: controller.shopMobileController.text.trim(),
                        shopwebsite:
                            controller.shopWebsiteController.text.trim(),
                        shopdesc: controller.shopDescController.text.trim(),
                      );
                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Shop updated");
                      Get.back();
                    },
                    child: normalText(
                      text: save,
                      color: fontGrey,
                    ),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: shopName,
                      hintText: nameHint,
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),

                    // label: shopName,
                    // hint: nameHint,
                    controller: controller.shopNameController),
                10.heightBox,
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: address,
                      hintText: shopAddressHint,
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    //label: address,
                    //hint: shopAddressHint,
                    controller: controller.shopAddressController),
                10.heightBox,
                TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: mobile,
                      hintText: shopMobileHint,
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    //label: mobile,
                    //hint: shopMobileHint,
                    controller: controller.shopMobileController),
                10.heightBox,
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: website,
                      hintText: shopMobileHint,
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    //label: website,
                    //hint: shopWebsiteHint,
                    controller: controller.shopWebsiteController),
                10.heightBox,
                TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: description,
                      hintText: shopDescHint,
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    //label: description,
                    //hint: shopDescHint,
                    //isDesc: true,
                    controller: controller.shopDescController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
