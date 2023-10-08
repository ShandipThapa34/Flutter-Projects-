import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/products_controller.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';



Widget productDropdown(
    {hint,
    required List<String> list,
    dropvalue,
    required ProductsController controller}) {
  return Obx(
    () => DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: normalText(
          text: "$hint",
          color: fontGrey,
        ),
        value: dropvalue.value == '' ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem(
            value: e,
            child: e.toString().text.make(),
          );
        }).toList(),
        onChanged: (newValue) {
          
          if (hint == "Category") {
            controller.subcategoryvalue.value = '';
            controller.populateSubcategory(newValue.toString());
          }
          dropvalue.value = newValue.toString();
        },
      ),
    )
        .box
        .roundedSM
        .padding(const EdgeInsets.symmetric(horizontal: 4))
        .color(textfieldGrey)
        .make(),
  );
}
