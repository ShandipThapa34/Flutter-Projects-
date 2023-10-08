import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/auth_controller.dart';
import 'package:picknpay_seller/views/home_screen/home.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/our_button.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepOrange,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.heightBox,
                normalText(text: welcome, size: 18.0),
                20.heightBox,
                Row(
                  children: [
                    Image.asset(
                      icLogo,
                      width: 70,
                      height: 70,
                    )
                        .box
                        .border(color: white)
                        .padding(const EdgeInsets.all(8))
                        .roundedSM
                        .make(),
                    10.widthBox,
                    boldText(text: appname, size: 18.0),
                  ],
                ),
                40.heightBox,
                normalText(text: loginTo, size: 18.0),
                10.heightBox,
                Obx(
                  () => Column(
                    children: [
                      TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          labelText: email,
                          labelStyle: TextStyle(color: orange),
                          prefixIcon: Icon(
                            Icons.email,
                            color: orange,
                          ),
                          focusedBorder: UnderlineInputBorder(),
                          hintText: emailHint,
                        ),
                      ),
                      10.heightBox,
                      TextFormField(
                        obscureText: true,
                        controller: controller.passwordController,
                        decoration: const InputDecoration(
                          labelText: password,
                          labelStyle: TextStyle(color: orange),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: orange,
                          ),
                          focusedBorder: UnderlineInputBorder(),
                          focusColor: orange,
                          hintText: passwordHint,
                        ),
                      ),
                      10.heightBox,
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: normalText(
                            text: forgetPassword,
                            color: orange,
                          ),
                        ),
                      ),
                      20.heightBox,
                      SizedBox(
                        width: context.screenWidth - 100,
                        child: controller.isLoading.value
                            ? loadingIndicator()
                            : ourButton(
                                title: login,
                                onPress: () async {
                                  controller.isLoading(true);

                                  await controller
                                      .loginMethod(
                                    context: context,
                                  )
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context,
                                          msg: "Logged in successfully");
                                      controller.isLoading(false);
                                      Get.offAll(() => const Home()); 
                                    } else {
                                      controller.isLoading(false);
                                    }
                                  });
                                },
                              ),
                      ),
                    ],
                  )
                      .box
                      .white
                      .rounded
                      .outerShadowMd
                      .padding(const EdgeInsets.all(8))
                      .make(),
                ),
                10.heightBox,
                Center(child: normalText(text: anyProblem)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
