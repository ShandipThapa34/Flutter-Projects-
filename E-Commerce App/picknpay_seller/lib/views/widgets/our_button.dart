import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

Widget ourButton({title, color = orange, onPress}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress,
    child: boldText(text: title, size: 16.0),
  );
}
