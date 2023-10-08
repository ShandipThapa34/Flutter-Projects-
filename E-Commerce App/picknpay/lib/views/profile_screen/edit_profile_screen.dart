import 'dart:io';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/profile_controller.dart';
import 'package:picknpay/widgets_common/custom_textfield.dart';
import 'package:picknpay/widgets_common/our_button.dart';

class EditProfilScreen extends StatelessWidget {
  final dynamic data;
  const EditProfilScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: "Edit Profile".text.fontFamily(semibold).white.make(),
      ),
      body: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //if data imageUrl and controller path is empty
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? Image.asset(
                      imgProfile,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  :
                  //if data imageUrl is not empty and controller path is empty
                  data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()

                      //else if controller is not empty but data url is
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.widthBox,
              10.heightBox,
              ourButton(
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textColor: whiteColor,
                  title: "Change"),
              const Divider(),
              20.heightBox,
              customTextField(
                controller: controller.nameController,
                title: name,
                hint: nameHint,
                isPass: false,
              ),

              customTextField(
                controller: controller.oldpassController,
                title: oldpass,
                hint: passwordHint,
                isPass: true,
              ),

              customTextField(
                controller: controller.newpassController,
                title: newpass,
                hint: passwordHint,
                isPass: true,
              ),
              20.heightBox,
              controller.isloading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(
                          color: redColor,
                          onPress: () async {
                            controller.isloading(true);

                            //if image is not selected
                            if (controller.profileImgPath.value.isNotEmpty) {
                              await controller.uploadProfileImage();
                            } else {
                              controller.profileImageLink = data['imageUrl'];
                            }

                            //if oldpassword matches the data
                            if (data['password'] ==
                                controller.oldpassController.text) {
                              await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassController.text,
                                newpassword: controller.newpassController.text,
                              );

                              await controller.updateProfile(
                                imgUrl: controller.profileImageLink,
                                name: controller.nameController.text,
                                password: controller.newpassController.text,
                              );
                              VxToast.show(context, msg: "Update Successfully");
                            } else {
                              VxToast.show(context, msg: "Wrong Old Password");
                              controller.isloading(false);
                            }
                          },
                          textColor: whiteColor,
                          title: "Save"),
                    ),
            ],
          )
              .box
              .white
              .padding(const EdgeInsets.all(16))
              .margin(const EdgeInsets.only(top: 30, left: 15, right: 15))
              .shadowSm
              .rounded
              .make(),
        ),
      ),
    );
  }
}
