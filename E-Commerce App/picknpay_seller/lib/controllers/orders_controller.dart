import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';

class OrdersController extends GetxController {
  var orders = [];
  // var orders = <dynamic>[];
  var newOrders = 0.obs;

  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;
  var cancelled = false.obs;

  getOrders(data) {
    orders.clear();
    for (var item in data['orders']) {
      if (item['vendor_id'] == currentUser!.uid) {
        orders.add(item);
      }
    }
    //orders.clear();
    // Filter orders based on the condition and use the 'data' parameter
    //orders.addAll(
    //    data['orders'].where((item) => item['vendor_id'] == currentUser!.uid));
  }

  changeStatus({title, status, docID}) async {
    var store = firestore.collection(ordersCollection).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));
  }

  newTotalOrders() async {
    QuerySnapshot snapshot = await firestore
        .collection(ordersCollection)
        .where('order_confirmed', isEqualTo: false)
        .where('order_cancelled', isEqualTo: false)
        .where('order_on_delivery', isEqualTo: false)
        .where('order_delivered', isEqualTo: false)
        .get();
    int length = snapshot.docs.length;
    return length;
  }
}
