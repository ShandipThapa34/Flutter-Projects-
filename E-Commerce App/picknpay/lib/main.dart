import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/views/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_239828e3a29f4cdc809ea3c4c2ab00d1',
      enabledDebugging: true,
      builder: (context, navKey) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: appname,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: whiteColor,
              ),
              elevation: 0,
              backgroundColor: redColor,
            ),
            fontFamily: regular,
          ),
          home: const SplashScreen(),
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
        );
      },
    );
  }
}
