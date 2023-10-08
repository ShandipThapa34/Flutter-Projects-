import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/home_controller.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  //text controllers for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];
  var vendors = [];

  var placingOrder = false.obs;

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();

    DocumentReference docRef =
        await firestore.collection(ordersCollection).add({
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'order_cancelled': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors),
    });
    String docId = docRef.id;
    docRef.update({
      'order_id': docId,
    });

    paymentDetails(
      orderId: docId,
      vendorId: vendors[0],
      paymentMethod: orderPaymentMethod,
      totalAmt: totalAmount,
      paymentstatus: orderPaymentMethod == "Khalti" ? "Paid" : "Pending",
    );

    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'p_id': productSnapshot[i]['p_id'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  paymentDetails(
      {required orderId,
      required vendorId,
      required paymentMethod,
      required totalAmt,
      required paymentstatus}) async {
    DocumentReference docRef =
        await firestore.collection(paymentsCollection).add({
      'payment_date': FieldValue.serverTimestamp(),
      'payment_by': currentUser!.uid,
      'payment_to': vendorId,
      'order_id': orderId,
      'payment_method': paymentMethod,
      'payment_status': paymentstatus,
      'total_amount': totalAmt,
    });

    String docId = docRef.id;

    docRef.update({
      'payment_id': docId,
    });
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
