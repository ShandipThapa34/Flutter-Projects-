import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picknpay/consts/consts.dart';

class FirestoreServices {
  //get users data
  static getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //get products according to category
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  //get products according to subcategory
  static getSubCategoryProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  //get cart
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  //delete document
  static deleteDocument(docid) {
    return firestore.collection(cartCollection).doc(docid).delete();
  }

  //get all chat messages
  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  //get all orders
  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  //get wishlists
  static getWishlists() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  //get all messages
  static getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  //get counts in profile
  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

  //get all products
  static allproducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  //get all featured products
  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  //search products
  static searchProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_name', isLessThanOrEqualTo: title)
        .get();
  }

  //get Todays deals products
  static todaysDealsProducts() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));
    return firestore
        .collection(productsCollection)
        .where('p_addedTime', isGreaterThanOrEqualTo: startOfDay)
        .where('p_addedTime', isLessThan: endOfDay)
        .get();
  }

  //get products to find top products
  static getTopProducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  //get Rating and Reviews
  static getRatingReviews({productId}) {
    return firestore
        .collection(ratingsAndReviewsCollection)
        .where('product_id', isEqualTo: productId)
        .get();
  }

  //get rating average
  static calculateAverageRating({productId}) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(ratingsAndReviewsCollection)
        .where('product_id', isEqualTo: productId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return 0;
    }
    int totalRatings = 0;
    int numberOfReviews = querySnapshot.docs.length;

    for (var doc in querySnapshot.docs) {
      totalRatings += doc['rating'] as int;
    }

    double averageRating = totalRatings / numberOfReviews;
    return averageRating;
  }

  static uploadProductRating(productId) async {
    double averageRating = await calculateAverageRating(productId: productId);
    double formattedRating = double.parse(averageRating.toStringAsFixed(1));

    firestore.collection(productsCollection).doc(productId).update({
      'p_rating': formattedRating,
    });
  }
}
