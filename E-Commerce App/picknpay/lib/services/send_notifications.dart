import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/services/notification_services.dart';

class SendNotifications {
  NotificationServices notificationServices = NotificationServices();
  final String serverKey =
      "AAAAbDm_-l0:APA91bE35OJN2EvKEqhCi5cxo_jbxUiKkBPqyvp0zqLHmTmWDEM_KgXJqf7OqyDSAGrxdt57jaTH9AxNSEiz4EhnVvpPKkDpif7XAUN-pzEfsG8Wu5mxBvg0eK5oZ2-fxo69QkH4m7cH";

  Future<void> sendNotificationToSeller({required sellerId}) async {
    firestore
        .collection(vendorsCollection)
        .doc(sellerId)
        .get()
        .then((userData) async {
      String sellerFCMToken = userData['fcmtoken'];
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'You have received a new order.',
              'title': 'New Order',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'type': 'order',
            },
            'to': sellerFCMToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Push Notification Sent Successfully');
      } else {
        print('Failed to send push notification');
      }
    });
  }
}
