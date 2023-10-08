import 'package:flutter/services.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/widgets_common/our_button.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.color(darkFontGrey).fontFamily(bold).size(18).make(),
        const Divider(),
        10.heightBox,
        "Are you sure you want to exit?"
            .text
            .color(darkFontGrey)
            .size(16)
            .make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(
              title: "Yes",
              color: redColor,
              textColor: whiteColor,
              onPress: () {
                SystemNavigator.pop();
              },
            ),
            ourButton(
              title: "No",
              color: redColor,
              textColor: whiteColor,
              onPress: () {
                Navigator.pop(context);
              },
            )
          ],
        )
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}
