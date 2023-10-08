import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/views/auth_screen/login_screen.dart';
import 'package:picknpay/views/home_screen/home.dart';
import 'package:picknpay/widgets_common/applogo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //creating a method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      //using getx

      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(() => const LoginScreen());
        } else {
          Get.to(() => const Home());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                icSplashBg,
                width: 300,
              ),
            ),
            10.heightBox,
            appLogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).white.size(20).make(),
            10.heightBox,
            appversion.text.white.size(15).make(),
          ],
        ),
      ),
    );
  }
}
