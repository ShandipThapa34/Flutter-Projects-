import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/auth_controller.dart';
import 'package:picknpay/views/auth_screen/signup_screen.dart';
import 'package:picknpay/views/home_screen/home.dart';
import 'package:picknpay/widgets_common/applogo_widget.dart';
import 'package:picknpay/widgets_common/bg_widget.dart';
import 'package:picknpay/widgets_common/custom_textfield.dart';
import 'package:picknpay/widgets_common/our_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    //text controller
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return bdWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              appLogoWidget(),
              10.heightBox,
              "Log In to $appname".text.fontFamily(bold).size(18).white.make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                        title: email,
                        hint: emailHint,
                        controller: emailController,
                        isPass: false,
                        keyboardType: TextInputType.emailAddress),
                    customTextField(
                      title: password,
                      hint: passwordHint,
                      controller: passwordController,
                      isPass: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: forgetPass.text.make(),
                      ),
                    ),
                    10.heightBox,
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(
                            color: redColor,
                            textColor: whiteColor,
                            title: login,
                            onPress: () async {
                              controller.isLoading(true);

                              await controller
                                  .loginMethod(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context,
                              )
                                  .then(
                                (value) {
                                  if (value != null) {
                                    VxToast.show(context, msg: loggedin);
                                    Get.to(() => const Home());
                                  } else {
                                    controller.isLoading(false);
                                  }
                                },
                              );
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    10.heightBox,
                    ourButton(
                      color: lightGolden,
                      textColor: redColor,
                      title: signup,
                      onPress: () {
                        Get.to(() => const SignupScreen());
                      },
                    ).box.width(context.screenWidth - 50).make(),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
