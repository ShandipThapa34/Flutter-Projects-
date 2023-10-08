import 'package:picknpay_seller/const/const.dart';

Widget productImages({required label, onPress}) {
  return "$label"
      .text
      .bold
      .color(fontGrey)
      .size(25.0)
      .makeCentered()
      .box
      .color(textfieldGrey)
      .size(100, 100)
      .roundedSM
      .make();
}
