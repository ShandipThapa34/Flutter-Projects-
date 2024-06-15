import 'package:flutter/material.dart';
import 'package:gharsewa/user_selection/user_selection_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserSelectionScreen(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/icons/home.png",
                width: 30,
                color: Colors.white,
              ),
            ),
            10.heightBox,
            //appLogoWidget(),
            "Ghar Sewa".text.fontFamily("sans_bold").white.size(20).make(),
            10.heightBox,
            "Version 1.0.0".text.white.size(15).make(),
          ],
        ),
      ),
    );
  }
}
