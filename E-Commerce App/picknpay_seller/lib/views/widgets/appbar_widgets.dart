import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: orange,
    automaticallyImplyLeading: false,
    title: boldText(text: title, color: white, size: 16.0),
    actions: [
      Center(
        child: normalText(
            text: intl.DateFormat('EEE, MMM d,' 'yy').format(DateTime.now()),
            color: white),
      ),
      10.widthBox,
    ],
  );
}
