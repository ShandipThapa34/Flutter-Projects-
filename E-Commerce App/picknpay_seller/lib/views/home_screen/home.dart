import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/controllers/home_controller.dart';
import 'package:picknpay_seller/controllers/orders_controller.dart';
import 'package:picknpay_seller/services/notification_services.dart';
import 'package:picknpay_seller/views/home_screen/home_screen.dart';
import 'package:picknpay_seller/views/orders_screen.dart/orders_screen.dart';
import 'package:picknpay_seller/views/products_screen/products_screen.dart';
import 'package:picknpay_seller/views/profile_screen.dart/profile_screen.dart';
import 'package:picknpay_seller/views/widgets/exit_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = Get.put(HomeController());
  var odrController = Get.put(OrdersController());
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    getNewTotalOrders();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      firestore.collection(vendorsCollection).doc(currentUser!.uid).update({
        'fcmtoken': value,
      });
    });
  }

  getNewTotalOrders() async {
    odrController.newOrders.value = await odrController.newTotalOrders();
  }

  @override
  Widget build(BuildContext context) {
    var navScreens = const [
      HomeScreen(),
      ProductsScreen(),
      OrdersScreen(),
      ProfileScreen(),
    ];

    var bottomNavBar = [
      const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProducts,
            color: darkGrey,
            width: 20,
          ),
          label: products),
      BottomNavigationBarItem(
          icon: Obx(
            () => Badge(
              label: Text(odrController.newOrders.value.toString()),
              isLabelVisible: odrController.newOrders.value == 0 ? false : true,
              smallSize: 12,
              child: Image.asset(
                icOrders,
                color: darkGrey,
                width: 20,
              ),
            ),
          ),
          label: orders),
      BottomNavigationBarItem(
          icon: Image.asset(
            icGeneralSettings,
            color: darkGrey,
            width: 20,
          ),
          label: settings),
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
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.navIndex.value,
            onTap: (index) {
              controller.navIndex.value = index;
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: orange,
            unselectedItemColor: darkGrey,
            items: bottomNavBar,
          ),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: navScreens.elementAt(controller.navIndex.value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
