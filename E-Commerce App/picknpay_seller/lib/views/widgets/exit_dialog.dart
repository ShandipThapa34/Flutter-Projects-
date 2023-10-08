import 'package:flutter/services.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/views/widgets/our_button.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.color(Colors.black).size(18).make(),
        const Divider(),
        10.heightBox,
        "Are you sure you want to exit?"
            .text
            .color(Colors.black)
            .size(16)
            .make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(
              title: "Yes",
              color: orange,
              onPress: () {
                SystemNavigator.pop();
              },
            ),
            ourButton(
              title: "No",
              color: orange,
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
