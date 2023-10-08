import 'package:picknpay/consts/consts.dart';

Widget customTextField({
  String? title,
  String? hint,
  controller,
  keyboardType = TextInputType.text,
  required bool isPass,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      10.heightBox,
      TextFormField(
        keyboardType: keyboardType,
        obscureText: isPass,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: regular,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),
      10.heightBox,
    ],
  );
}
