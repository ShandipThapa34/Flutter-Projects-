import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/products_controller.dart';
import 'package:picknpay_seller/services/store_services.dart';
import 'package:picknpay_seller/views/products_screen/add_product.dart';
import 'package:picknpay_seller/views/products_screen/edit_product.dart';
import 'package:picknpay_seller/views/products_screen/product_details.dart';
import 'package:picknpay_seller/views/widgets/appbar_widgets.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final VxPopupMenuController _popupMenuController = VxPopupMenuController();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: orange,
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const AddProduct());
        },
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: normalText(
                  text: "No products added!", color: fontGrey, size: 16.0),
            );
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(
                            () => ProductDetails(
                              data: data[index],
                            ),
                          );
                        },
                        leading: Image.network(data[index]['p_imgs'][0],
                            width: 100, height: 100, fit: BoxFit.contain),
                        title: boldText(
                            text: "${data[index]['p_name']}", color: fontGrey),
                        subtitle: Row(
                          children: [
                            normalText(
                                text: "Rs. ${data[index]['p_price']}",
                                color: orange),
                            10.widthBox,
                            boldText(
                                text: data[index]['is_featured'] == true
                                    ? "Featured"
                                    : '',
                                color: green),
                          ],
                        ),
                        trailing: VxPopupMenu(
                          controller: _popupMenuController,
                          menuBuilder: () => Column(
                            children: List.generate(
                              popupMenuTitles.length,
                              (i) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      popupMenuIcons[i],
                                      color: data[index]['featured_id'] ==
                                                  currentUser!.uid &&
                                              i == 0
                                          ? green
                                          : fontGrey,
                                    ),
                                    5.widthBox,
                                    normalText(
                                      text: data[index]['featured_id'] ==
                                                  currentUser!.uid &&
                                              i == 0
                                          ? "Remove featured"
                                          : popupMenuTitles[i],
                                      color: fontGrey,
                                    )
                                  ],
                                ).onTap(
                                  () async {
                                    switch (i) {
                                      case 0:
                                        _popupMenuController.hideMenu();
                                        if (data[index]['is_featured'] ==
                                            true) {
                                          await controller
                                              .removeFeatured(data[index].id);

                                          // ignore: use_build_context_synchronously
                                          VxToast.show(context, msg: "Removed");
                                        } else {
                                          _popupMenuController.hideMenu();
                                          await controller
                                              .addFeatured(data[index].id);

                                          // ignore: use_build_context_synchronously
                                          VxToast.show(context, msg: "Added");
                                        }
                                        break;
                                      case 1:
                                        _popupMenuController.hideMenu();
                                        await controller.getCategories();
                                        controller.populateCategoryList();
                                        Get.to(
                                          () => EditProduct(
                                            docId: data[index].id,
                                            productName: data[index]['p_name'],
                                            productDesc: data[index]['p_desc'],
                                            productPrice: data[index]
                                                ['p_price'],
                                            productQuantity: data[index]
                                                ['p_quantity'],
                                            productCategory: data[index]
                                                ['p_category'],
                                            productSubcat: data[index]
                                                ['p_subcategory'],
                                            pImagesLinks: [
                                              data[index]['p_imgs']
                                            ],
                                          ),
                                        );
                                        break;
                                      case 2:
                                        _popupMenuController.hideMenu();
                                        await controller
                                            .removeProduct(data[index].id);

                                        // ignore: use_build_context_synchronously
                                        VxToast.show(context,
                                            msg: "Product removed");
                                        break;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ).box.white.width(200).rounded.make(),
                          clickType: VxClickType.singleClick,
                          child: const Icon(Icons.more_vert_rounded),
                        ),
                      ),
                    ),
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
