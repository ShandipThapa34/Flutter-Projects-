import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/auth_controller.dart';
import 'package:picknpay/views/auth_screen/login_screen.dart';
import 'package:picknpay/widgets_common/applogo_widget.dart';
import 'package:picknpay/widgets_common/bg_widget.dart';
import 'package:picknpay/widgets_common/custom_textfield.dart';
import 'package:picknpay/widgets_common/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bdWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              appLogoWidget(),
              10.heightBox,
              "Join the $appname"
                  .text
                  .fontFamily(regular)
                  .size(18)
                  .white
                  .make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      title: name,
                      hint: nameHint,
                      controller: nameController,
                      isPass: false,
                      keyboardType: TextInputType.name,
                    ),
                    customTextField(
                      title: email,
                      hint: emailHint,
                      controller: emailController,
                      isPass: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    customTextField(
                      title: password,
                      hint: passwordHint,
                      controller: passwordController,
                      isPass: true,
                    ),
                    customTextField(
                      title: retypePassword,
                      hint: passwordHint,
                      controller: passwordRetypeController,
                      isPass: true,
                    ),
                    10.heightBox,
                    Row(
                      children: [
                        Checkbox(
                          activeColor: redColor,
                          checkColor: whiteColor,
                          value: isCheck,
                          onChanged: (newValue) {
                            setState(() {
                              isCheck = newValue;
                            });
                          },
                        ),
                        10.heightBox,
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  text: termAndCond,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  ),
                                ),
                                TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.heightBox,
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(
                            color: isCheck == true ? redColor : fontGrey,
                            textColor: whiteColor,
                            title: signup,
                            onPress: () async {
                              if (isCheck != false &&
                                  nameController.text.isNotEmptyAndNotNull &&
                                  emailController.text.isNotEmptyAndNotNull &&
                                  passwordController
                                      .text.isNotEmptyAndNotNull &&
                                  passwordRetypeController
                                      .text.isNotEmptyAndNotNull) {
                                controller.isLoading(true);
                                try {
                                  await controller
                                      .signupMethod(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  )
                                      .then(
                                    (value) {
                                      return controller.storeUserData(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                      );
                                    },
                                  ).then((value) {
                                    VxToast.show(context, msg: accountCreated);
                                    Get.to(() => const LoginScreen());
                                    controller.isLoading(false);
                                  });
                                } catch (e) {
                                  auth.signOut();
                                  VxToast.show(context, msg: e.toString());
                                  controller.isLoading(false);
                                }
                              }
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    //wrapping into gesture detector of velocity x
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        alreadyHavaAccount.text.color(fontGrey).make(),
                        login.text.color(redColor).make().onTap(
                          () {
                            Get.back();
                          },
                        )
                      ],
                    )
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
