import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/home_controller.dart';
import 'package:picknpay/controller/product_controller.dart';
import 'package:picknpay/services/notification_services.dart';
import 'package:picknpay/views/cart_screen/cart_screen.dart';
import 'package:picknpay/views/category_screen/category_screen.dart';
import 'package:picknpay/views/home_screen/home_screen.dart';
import 'package:picknpay/views/profile_screen/profile_screen.dart';
import 'package:picknpay/widgets_common/exit_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NotificationServices notificationServices = NotificationServices();
  var pController = Get.put(ProductController());
  var controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    recalculateCart();
    notificationServices.requestNotificationPermission();
    // ignore: use_build_context_synchronously
    notificationServices.firebaseInit(context);
    // ignore: use_build_context_synchronously
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      firestore.collection(usersCollection).doc(currentUser!.uid).update({
        'fcmtoken': value,
      });
    });
  }

  recalculateCart() async {
    pController.itemsInCart.value = await pController.cartItemsLength();
  }

  @override
  Widget build(BuildContext context) {
    //init home controller

    var navBarItem = [
      BottomNavigationBarItem(
        icon: Image.asset(
          icHome,
          width: 26,
        ),
        label: home,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          icCategories,
          width: 26,
        ),
        label: categories,
      ),
      BottomNavigationBarItem(
        icon: Obx(
          () => Badge(
            label: Text(pController.itemsInCart.value.toString()),
            isLabelVisible: pController.itemsInCart.value == 0 ? false : true,
            smallSize: 12,
            textColor: whiteColor,
            child: Image.asset(
              icCart,
              width: 26,
            ),
          ),
        ),
        label: cart,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          icProfile,
          width: 26,
        ),
        label: account,
      ),
    ];

    var navBody = const [
      HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: redColor,
            selectedLabelStyle: const TextStyle(
              fontFamily: semibold,
            ),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navBarItem,
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
