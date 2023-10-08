import 'dart:io';
import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/profile_controller.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({super.key, this.username});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.username!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: boldText(text: editProfile, color: fontGrey, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator()
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      //if image is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      //if oldpassword matches the data
                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                          email: controller.snapshotData['email'],
                          password: controller.oldpassController.text,
                          newpassword: controller.newpassController.text,
                        );

                        await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.newpassController.text,
                        );
                        // ignore: use_build_context_synchronously
                        VxToast.show(context, msg: "Update Successfully");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.snapshotData['password'],
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        VxToast.show(context, msg: "Some error occured!");
                        controller.isloading(false);
                      }
                    },
                    child: normalText(
                      text: save,
                      color: fontGrey,
                    ),
                  ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //if data imageUrl and controller path is empty
              controller.snapshotData['imageUrl'] == '' &&
                      controller.profileImgPath.isEmpty
                  ? Image.asset(
                      imgProfile,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  :
                  //if data imageUrl is not empty and controller path is empty
                  controller.snapshotData['imageUrl'] != '' &&
                          controller.profileImgPath.isEmpty
                      ? Image.network(
                          controller.snapshotData['imageUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ).box.roundedFull.clip(Clip.antiAlias).make()

                      //else if controller is not empty but data url is
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),

              10.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: orange),
                onPressed: () {
                  controller.changeImage(context);
                },
                child: normalText(text: changeImage),
              ),
              10.heightBox,
              const Divider(),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: name,
                    hintText: "eg. Rajesh Hamal",
                    labelStyle: TextStyle(color: orange),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                  ),
                  //label: name,
                  //hint: "eg. Roronoa Zoro",
                  controller: controller.nameController),
              20.heightBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child:
                      boldText(text: "Change your password", color: fontGrey)),
              10.heightBox,
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: password,
                    hintText: passwordHint,
                    labelStyle: TextStyle(color: orange),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                  ),
                  //label: password,
                  //hint: passwordHint,
                  controller: controller.oldpassController),
              10.heightBox,
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: confirmPass,
                    hintText: passwordHint,
                    labelStyle: TextStyle(color: orange),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                  ),
                  //label: confirmPass,
                  //hint: passwordHint,
                  controller: controller.newpassController),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
