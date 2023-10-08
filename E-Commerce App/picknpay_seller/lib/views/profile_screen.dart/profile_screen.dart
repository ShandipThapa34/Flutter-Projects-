import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/auth_controller.dart';
import 'package:picknpay_seller/controllers/profile_controller.dart';
import 'package:picknpay_seller/services/store_services.dart';
import 'package:picknpay_seller/views/auth_screen/login_screen.dart';
import 'package:picknpay_seller/views/messages_screen/messages_screen.dart';
import 'package:picknpay_seller/views/profile_screen.dart/edit_profilescreen.dart';

import 'package:picknpay_seller/views/shop_screen/shop_settings_screen.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orange,
        automaticallyImplyLeading: false,
        title: boldText(text: settings, color: white, size: 16.0),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditProfileScreen(
                    username: controller.snapshotData['vendor_name'],
                  ));
            },
            icon: const Icon(
              Icons.edit,
              color: white,
            ),
          ),
          TextButton(
            onPressed: () async {
              await Get.find<AuthController>().signoutMethod(context);
              Get.offAll(() => const LoginScreen());
            },
            child: normalText(
              text: logout,
              color: white,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: StoreServices.getProfile(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            controller.snapshotData = snapshot.data!.docs[0];

            return Column(
              children: [
                ListTile(
                  leading: controller.snapshotData['imageUrl'] == ''
                      ? Image.asset(
                          imgProfile,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      : Image.network(
                          controller.snapshotData['imageUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
                  title: boldText(
                      text: "${controller.snapshotData['vendor_name']}",
                      color: fontGrey),
                  subtitle: normalText(
                      text: "${controller.snapshotData['email']}",
                      color: fontGrey),
                ),
                const Divider(),
                10.heightBox,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(
                      profileButtonsTitles.length,
                      (index) => ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => const ShopSettings());
                              break;
                            case 1:
                              Get.to(() => const MessagesScreen());
                              break;
                          }
                        },
                        leading: Icon(profileButtonsIcons[index]),
                        title: normalText(
                            text: profileButtonsTitles[index], color: fontGrey),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
