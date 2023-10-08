import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/services/firestore_services.dart';
import 'package:picknpay/views/chat_screen/chat_screen.dart';
import 'package:picknpay/widgets_common/loading_indicator.dart';
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Messages".text.fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      var t = data[index]['created_on'].toDate();
                      var time = intl.DateFormat("h:ma").format(t);

                      return Card(
                        child: ListTile(
                          onTap: () {
                            Get.to(() => const ChatScreen(), arguments: [
                              data[index]['friend_name'],
                              data[index]['toId'],
                            ]);
                          },
                          leading: const CircleAvatar(
                            backgroundColor: redColor,
                            child: Icon(
                              Icons.person,
                              color: whiteColor,
                            ),
                          ),
                          title: "${data[index]['friend_name']}"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          subtitle: "${data[index]['last_msg']}".text.make(),
                          trailing: time.text.color(darkFontGrey).make(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
