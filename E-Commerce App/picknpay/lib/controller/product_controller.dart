import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/home_controller.dart';
import 'package:picknpay/models/category_model.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var totalPrice = 0.obs;
  var itemsInCart = 0.obs;
  var subcat = [];

  var isFav = false.obs;

  getSubCatogories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCart({
    title,
    img,
    sellername,
    productId,
    qty,
    tprice,
    context,
    vendorID,
  }) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'p_id': productId,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
    totalItemsInCart();
  }

  totalItemsInCart() async {
    QuerySnapshot items = await firestore.collection(cartCollection).get();
    bool cItems = items.docs.isNotEmpty;
    return cItems;
  }

  cartItemsLength() async {
    QuerySnapshot cLength = await firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: currentUser!.uid)
        .get();
    int length = cLength.docs.length;
    return length;
  }

  hasUserReviewedProduct({productId}) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(ratingsAndReviewsCollection)
        .where('product_id', isEqualTo: productId)
        .where('reviewer_id', isEqualTo: currentUser!.uid)
        .get();
    bool userHasReviewed = querySnapshot.docs.isNotEmpty;
    return userHasReviewed;
  }

  addRatingReview({
    required int rating,
    required String review,
    required String productId,
    context,
  }) async {
    await firestore.collection(ratingsAndReviewsCollection).add({
      'rating': rating,
      'review': review,
      'product_id': productId,
      'reviewer_id': currentUser!.uid,
      'reviewer_name': Get.find<HomeController>().username,
      'reviewed_time': FieldValue.serverTimestamp(),
    });
  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
