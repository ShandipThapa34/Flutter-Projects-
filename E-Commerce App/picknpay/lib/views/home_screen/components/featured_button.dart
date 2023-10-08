import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/views/home_screen/components/featured_categories.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(
        icon,
        height: 60,
        width: 60,
        fit: BoxFit.contain,
      ),
      10.widthBox,
      Expanded(
        child: Text(
          title.toString(),
          style: const TextStyle(fontFamily: semibold, color: darkFontGrey),
        ),
      )
      //title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  )
      .box
      .white
      .width(200)
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .padding(const EdgeInsets.all(8))
      .roundedSM
      .outerShadowSm
      .make()
      .onTap(() {
    Get.to(() => FeaturedCategories(title: title));
  });
}
