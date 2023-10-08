import 'package:picknpay/consts/consts.dart';

Widget appLogoWidget() {
  return Column(
    children: [
      const Padding(padding: EdgeInsets.zero),
      Image.asset(icAppLogo)
          .box
          .white
          .size(77, 77)
          .padding(const EdgeInsets.all(8))
          .rounded
          .make(),
      //Image.asset(icAppName).box.size(125, 100).make()
    ],
  );
}
