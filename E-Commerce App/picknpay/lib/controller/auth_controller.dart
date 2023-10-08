import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/views/auth_screen/login_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  //login method
  Future<UserCredential?> loginMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod({name, email, password, context}) async {
    UserCredential? userCredential;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // Get current user ID
  String? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  //storing data method
  storeUserData({name, email, password}) {
    String? userId = getUserId();
    firestore.collection(usersCollection).doc(userId).set({
      'name': name,
      'email': email,
      'password': password,
      'imageUrl': '',
      'id': userId,
      'cart_count': "0",
      'wishlist_count': "0",
      'order_count': "0",
      'fcmtoken': '',
    });
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
