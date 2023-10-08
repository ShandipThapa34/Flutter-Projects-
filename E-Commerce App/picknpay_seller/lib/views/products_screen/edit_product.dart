import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/products_controller.dart';
import 'package:picknpay_seller/views/products_screen/components/product_images.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class EditProduct extends StatefulWidget {
  final String docId;
  final String productName;
  final String productDesc;
  final String productPrice;
  final String productQuantity;
  final String productCategory;
  final String productSubcat;
  final List<dynamic> pImagesLinks;

  const EditProduct({
    super.key,
    required this.productName,
    required this.productDesc,
    required this.productPrice,
    required this.productQuantity,
    required this.docId,
    required this.productCategory,
    required this.productSubcat,
    required this.pImagesLinks,
  });

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  List<Color> selectedColors = [];
  var controller = Get.find<ProductsController>();
  @override
  void initState() {
    super.initState();

    for (var item in widget.pImagesLinks) {
      if (item != null) {
        controller.pImagesLinks = item;
      }
    }
  }

  Future<void> _handleCategoryChange(newValue) async {
    await Future.delayed(
        Duration.zero); // Schedule the code to run after the build process
    setState(() {
      controller.categoryvalue.value = newValue.toString();
      controller.subcategoryvalue.value = '';
      controller.populateSubcategory(newValue.toString());
    });
  }

  Future<void> _handleSubcategoryChange(newValue) async {
    await Future.delayed(
        Duration.zero); // Schedule the code to run after the build process
    setState(() {
      controller.subcategoryvalue.value = newValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          controller.pnameController.clear();
          controller.pdescController.clear();
          controller.ppriceController.clear();
          controller.pquantityController.clear();
          controller.categoryvalue.value = '';
          controller.subcategoryvalue.value = '';
          controller.clearImages();
          return true;
        },
        child: Scaffold(
          backgroundColor: cream,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: boldText(text: "Edit Product", color: fontGrey, size: 16.0),
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
                          await controller.updateProduct(context, widget.docId);
                          Get.back();
                        }
                      },
                      child: boldText(text: "Update", color: fontGrey),
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
                    controller: controller.pnameController
                      ..text = widget.productName,
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
                    controller: controller.pdescController
                      ..text = widget.productDesc,
                  ),
                  10.heightBox,
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Price",
                      hintText: "eg 3000",
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    controller: controller.ppriceController
                      ..text = widget.productPrice,
                  ),
                  10.heightBox,
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      hintText: "eg 30",
                      labelStyle: TextStyle(color: orange),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                    controller: controller.pquantityController
                      ..text = widget.productQuantity,
                  ),
                  10.heightBox,
                  Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: normalText(
                          text: "Category",
                          color: fontGrey,
                        ),
                        value: controller.categoryvalue.value == ''
                            ? null
                            : controller.categoryvalue.value,
                        isExpanded: true,
                        items: controller.categoryList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: e.toString().text.make(),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          _handleCategoryChange(newValue);
                        },
                      ),
                    )
                        .box
                        .roundedSM
                        .padding(const EdgeInsets.symmetric(horizontal: 4))
                        .color(textfieldGrey)
                        .make(),
                  ),
                  10.heightBox,
                  Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: normalText(
                          text: "Sub Category",
                          color: fontGrey,
                        ),
                        value: controller.subcategoryvalue.value == ''
                            ? null
                            : controller.subcategoryvalue.value,
                        isExpanded: true,
                        items: controller.subcategoryList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: e.toString().text.make(),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          _handleSubcategoryChange(newValue);
                        },
                      ),
                    )
                        .box
                        .roundedSM
                        .padding(const EdgeInsets.symmetric(horizontal: 4))
                        .color(textfieldGrey)
                        .make(),
                  ),
                  10.heightBox,
                  const Divider(),
                  boldText(text: "Choose Product Images:", color: fontGrey),
                  10.heightBox,
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        return Stack(
                          children: [
                            index < controller.pImagesLinks.length &&
                                    controller.pImagesList[index] == null
                                ? Image.network(
                                    controller.pImagesLinks[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  )
                                : controller.pImagesList[index] != null
                                    ? Image.file(
                                        controller.pImagesList[index],
                                        width: 100,
                                        height: 100,
                                      )
                                    : productImages(label: "+"),
                            if (index < widget.pImagesLinks.length ||
                                controller.pImagesList[index] != null)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (index == 0) {
                                      VxToast.show(context,
                                          msg: "First Image cann't be deleted");
                                    } else {
                                      controller.deleteImage(
                                          index, widget.docId);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: orange,
                                  ),
                                ),
                              ),
                          ],
                        ).box.clip(Clip.antiAlias).make().onTap(() {
                          controller.pickImage(index, context);
                        });
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
