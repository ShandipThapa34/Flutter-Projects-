import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/cart_controller.dart';
import 'package:picknpay/controller/product_controller.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/cart_screen/shipping_screen.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';
import 'package:picknpay/widgets_common/our_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var controller = Get.put(CartController());
  var pController = Get.find<ProductController>();
  @override
  void initState() {
    super.initState();
    recalculateCart();
  }

  recalculateCart() async {
    pController.itemsInCart.value = await pController.cartItemsLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.fontFamily(semibold).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () async {
            bool isCartEmpty = await pController.totalItemsInCart();

            if (isCartEmpty == true) {
              Get.to(() => const ShippingDetails());
            } else {
              // ignore: use_build_context_synchronously
              VxToast.show(context,
                  msg: "Cart is Empty, Add items to your cart first!");
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Proceed to shipping",
        ),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is empty!".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              "${data[index]['img']}",
                              width: 80,
                              fit: BoxFit.contain,
                            ),
                            title:
                                "${data[index]['title']} (x${data[index]['qty']})"
                                    .text
                                    .size(16)
                                    .fontFamily(semibold)
                                    .make(),
                            subtitle: "Rs.${data[index]['tprice']}"
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            trailing: const Icon(
                              Icons.delete,
                              color: redColor,
                            ).onTap(() async {
                              FirestoreServices.deleteDocument(data[index].id);
                              pController.itemsInCart.value =
                                  await pController.cartItemsLength();
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total Price"
                          .text
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .make(),
                      Obx(
                        () => "Rs.${controller.totalP.value}"
                            .text
                            .fontFamily(semibold)
                            .color(redColor)
                            .make(),
                      ),
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(12))
                      .width(context.screenWidth - 60)
                      .color(lightGolden)
                      .roundedSM
                      .make(),
                  10.heightBox,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
