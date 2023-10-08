import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/consts/lists.dart';
import 'package:picknpay/controller/auth_controller.dart';
import 'package:picknpay/controller/profile_controller.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/chat_screen/messaging_screen.dart';
import 'package:picknpay/views/orders_screen/orders_screen.dart';
import 'package:picknpay/views/profile_screen/components/details_card.dart';
import 'package:picknpay/views/profile_screen/edit_profile_screen.dart';
import 'package:picknpay/views/wishlist_screen/wishlist_screen.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: "Account".text.fontFamily(semibold).make(),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else {
            var data = snapshot.data!.docs[0];

            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //user details section
                    10.heightBox,
                    Row(
                      children: [
                        data['imageUrl'] == ''
                            ? Image.asset(
                                imgProfile,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make()
                            : Image.network(
                                data['imageUrl'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make(),
                        10.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                              "${data['email']}".text.make(),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: const Icon(
                                  Icons.edit,
                                  color: redColor,
                                ).onTap(() {
                                  controller.nameController.text = data['name'];

                                  Get.to(() => EditProfilScreen(data: data));
                                }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: whiteColor,
                                ),
                                onPressed: () async {
                                  await Get.put(AuthController())
                                      .signoutMethod(context);
                                },
                                child: "Log Out"
                                    .text
                                    .color(redColor)
                                    .fontFamily(semibold)
                                    .make(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                        .box
                        .white
                        .padding(const EdgeInsets.all(8))
                        .margin(const EdgeInsets.only(left: 8, right: 8))
                        .shadowXs
                        .rounded
                        .make(),
                    20.heightBox,

                    //cart, wishlist, order section

                    FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: loadingIndicator(),
                          );
                        } else {
                          var countData = snapshot.data;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(
                                  count: countData[0].toString(),
                                  width: context.screenWidth / 3.2,
                                  title: "in your cart"),
                              detailsCard(
                                  count: countData[1].toString(),
                                  width: context.screenWidth / 3.2,
                                  title: "in your wishlist"),
                              detailsCard(
                                  count: countData[2].toString(),
                                  width: context.screenWidth / 3.2,
                                  title: "your orders"),
                            ],
                          );
                        }
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     detailsCard(
                    //         count: data['cart_count'],
                    //         width: context.screenWidth / 3.4,
                    //         title: "in your cart"),
                    //     detailsCard(
                    //         count: data['wishlist_count'],
                    //         width: context.screenWidth / 3.4,
                    //         title: "in your wishlist"),
                    //     detailsCard(
                    //         count: data['order_count'],
                    //         width: context.screenWidth / 3.4,
                    //         title: "your orders"),
                    //   ],
                    // ),

                    //buttons section
                    25.heightBox,
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: lightGrey,
                        );
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const OrdersScreen());
                                break;
                              case 1:
                                Get.to(() => const WishlistScreen());
                                break;
                              case 2:
                                Get.to(() => const MessagesScreen());
                                break;
                            }
                          },
                          leading: Image.asset(
                            profileButtonsIcon[index],
                            width: 22,
                            color: darkFontGrey,
                          ),
                          title: profileButtonsList[index]
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                        );
                      },
                    )
                        .box
                        .white
                        .rounded
                        .shadowSm
                        .margin(const EdgeInsets.only(left: 12, right: 12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .make(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
