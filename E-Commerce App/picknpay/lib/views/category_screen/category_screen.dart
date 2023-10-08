import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/consts/lists.dart';
import 'package:picknpay/controller/product_controller.dart';
import 'package:picknpay/views/category_screen/category_details.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: categories.text.fontFamily(bold).make(),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 220,
          ),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(
                  categoryImages[index],
                  width: 200,
                  height: 160,
                  fit: BoxFit.contain,
                ),
                10.heightBox,
                categoriesList[index]
                    .text
                    .color(darkFontGrey)
                    .align(TextAlign.center)
                    .make(),
              ],
            ).box.white.rounded.clip(Clip.antiAlias).outerShadowMd.make().onTap(
              () {
                controller.getSubCatogories(categoriesList[index]);

                Get.to(
                  () => CategoryDetails(title: categoriesList[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
