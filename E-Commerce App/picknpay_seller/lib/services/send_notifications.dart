import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/services/notification_services.dart';

class SendNotifications {
  NotificationServices notificationServices = NotificationServices();
  final String serverKey =
      "AAAAbDm_-l0:APA91bE35OJN2EvKEqhCi5cxo_jbxUiKkBPqyvp0zqLHmTmWDEM_KgXJqf7OqyDSAGrxdt57jaTH9AxNSEiz4EhnVvpPKkDpif7XAUN-pzEfsG8Wu5mxBvg0eK5oZ2-fxo69QkH4m7cH";

  Future<void> sendNotificationToBuyer(
      {required buyerId, required title, required body}) async {
    firestore
        .collection(usersCollection)
        .doc(buyerId)
        .get()
        .then((userData) async {
      String buyerFCMToken = userData['fcmtoken'];
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'type': 'order',
            },
            'to': buyerFCMToken,
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
