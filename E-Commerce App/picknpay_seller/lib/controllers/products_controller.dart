import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/home_controller.dart';
import 'package:picknpay_seller/models/category_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ProductsController extends GetxController {
  var isloading = false.obs;

  //text field controller
  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();

    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategory(cat) {
    subcategoryList.clear();

    var data = category.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  deleteImage(int index, docId) async {
    var imageToDelete = pImagesList[index];
    if (index < pImagesLinks.length) {
      // Image is from Firebase, delete the URL from the product collection
      await firestore.collection(productsCollection).doc(docId).update({
        'p_imgs': FieldValue.arrayRemove([pImagesLinks[index]]),
      });
    } else if (imageToDelete != null && imageToDelete is File) {
      // Image is selected from gallery, delete the local file
      imageToDelete.deleteSync();
    }

    // Clear the image in the local list
    pImagesList[index] = null;

    // Update the UI
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void clearImages() {
    for (int i = 0; i < pImagesList.length; i++) {
      pImagesList[i] = null;
    }
  }

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendor/${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  uploadProduct(context) async {
    DocumentReference docRef =
        await firestore.collection(productsCollection).add({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_addedTime': FieldValue.serverTimestamp(),
      'p_desc': pdescController.text.trim(),
      'p_name': pnameController.text.trim(),
      'p_price': ppriceController.text.trim(),
      'p_quantity': pquantityController.text.trim(),
      'p_seller': Get.find<HomeController>().username,
      'p_rating': '0.0',
      'vendor_id': currentUser!.uid,
      'featured_id': '',
    });

    String docId = docRef.id;
    docRef.update({
      'p_id': docId,
    });

    isloading(false);

    VxToast.show(context, msg: "Product uploaded");

    pnameController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquantityController.clear();
    categoryList.clear();
    subcategoryList.clear();
  }

  updateProduct(context, docId) async {
    await firestore.collection(productsCollection).doc(docId).update({
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_desc': pdescController.text.trim(),
      'p_name': pnameController.text.trim(),
      'p_price': ppriceController.text.trim(),
      'p_quantity': pquantityController.text.trim(),
    });

    isloading(false);

    VxToast.show(context, msg: "Product updated");
  }

  addFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }
}
