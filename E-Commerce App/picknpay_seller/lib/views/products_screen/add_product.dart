import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/products_controller.dart';
import 'package:picknpay_seller/views/products_screen/components/product_dropdown.dart';
import 'package:picknpay_seller/views/products_screen/components/product_images.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          controller.pnameController.clear();
          controller.pdescController.clear();
          controller.ppriceController.clear();
          controller.pquantityController.clear();
          controller.categoryvalue.value = '';
          controller.subcategoryvalue.value = '';
          return true;
        },
        child: Scaffold(
          backgroundColor: cream,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: boldText(text: "Add Product", color: fontGrey, size: 16.0),
            actions: [
              controller.isloading.value
                  ? loadingIndicator()
                  : TextButton(
                      onPressed: () async {
                        String name = controller.pnameController.text.trim();
                        String description =
                            controller.pdescController.text.trim();
                        String price = controller.ppriceController.text.trim();
                        String quantity =
                            controller.pquantityController.text.trim();
                        String category = controller.categoryvalue.value;
                        String subcategory = controller.subcategoryvalue.value;

                        // Check if any field is empty or null
                        if (name.isEmpty ||
                            description.isEmpty ||
                            price.isEmpty ||
                            quantity.isEmpty ||
                            category == '' ||
                            subcategory == '') {
                          VxToast.show(context, msg: "Enter all the details");
                        } else {
                          controller.isloading(true);
                          await controller.uploadImages();

                          // ignore: use_build_context_synchronously
                          await controller.uploadProduct(context);
                          Get.back();
                        }
                      },
                      child: boldText(text: save, color: fontGrey),
                    )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.heightBox,
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Product Name",
                        hintText: "eg Iphone 14",
                        labelStyle: TextStyle(color: orange),
                        focusedBorder: OutlineInputBorder(),
                        border: OutlineInputBorder()),
                    controller: controller.pnameController,
                  ),
                  10.heightBox,
                  TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Product Details",
                      hintText: "Description of product",
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    controller: controller.pdescController,
                  ),
                  10.heightBox,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price",
                      hintText: "eg 3000",
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    controller: controller.ppriceController,
                  ),
                  10.heightBox,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      hintText: "eg 30",
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    controller: controller.pquantityController,
                  ),
                  10.heightBox,
                  productDropdown(
                    hint: "Category",
                    list: controller.categoryList,
                    dropvalue: controller.categoryvalue,
                    controller: controller,
                  ),
                  10.heightBox,
                  productDropdown(
                    hint: "Sub Category",
                    list: controller.subcategoryList,
                    dropvalue: controller.subcategoryvalue,
                    controller: controller,
                  ),
                  10.heightBox,
                  const Divider(),
                  boldText(text: "Choose Product Images:", color: fontGrey),
                  10.heightBox,
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => controller.pImagesList[index] != null
                            ? Image.file(
                                controller.pImagesList[index],
                                width: 100,
                                height: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : productImages(label: "+").onTap(() {
                                controller.pickImage(index, context);
                              }),
                      ),
                    ),
                  ),
                  10.heightBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
