import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:intl/intl.dart' as intl;

Widget chatBubble(DocumentSnapshot data) {
  var t = data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);
  return Directionality(
    textDirection:
        data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    //textDirection: TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: data['uid'] == currentUser!.uid ? orange : fontGrey,
        //color: orange,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data['msg']}".text.size(16).white.make(),
          //normalText(text: "Your message here.."),
          10.heightBox,
          time.text.color(Colors.white.withOpacity(0.5)).make(),
          //normalText(text: "10:30AM"),
        ],
      ),
    ),
  );
}
