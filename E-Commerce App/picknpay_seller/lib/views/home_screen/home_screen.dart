import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picknpay_seller/const/const.dart';
import 'package:picknpay_seller/services/store_services.dart';
import 'package:picknpay_seller/views/products_screen/product_details.dart';
import 'package:picknpay_seller/views/widgets/appbar_widgets.dart';
import 'package:picknpay_seller/views/widgets/dashboard_button.dart';
import 'package:picknpay_seller/views/widgets/loading_indicator.dart';
import 'package:picknpay_seller/views/widgets/text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int orderLength = 0;
  int totalsales = 0;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
    getTotalSales();
    calculateAverageRating();
  }

  Future<void> fetchData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    int totalOrders = querySnapshot.docs.length;

    if (mounted) {
      setState(() {
        orderLength = totalOrders;
      });
    }
  }

  Future<int> getTotalSales() async {
    // int totalSales = 0;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection(ordersCollection)
        .where('order_delivered', isEqualTo: true)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      var totalPrice = document['total_amount'] as num?;

      if (totalPrice != null) {
        totalsales += totalPrice.toInt();
      }
    }

    return totalsales;
  }

  Future<double> calculateAverageRating() async {
    QuerySnapshot<Map<String, dynamic>> ratingsSnapshot =
        await FirebaseFirestore.instance
            .collection(ratingsAndReviewsCollection)
            .get();

    int totalRatings = 0;
    int numberOfRatings = ratingsSnapshot.docs.length;

    for (var document in ratingsSnapshot.docs) {
      // Assuming 'rating' is the field name in your Firestore document
      totalRatings += document.data()['rating'] as int;
    }

    // Calculate the average rating
    averageRating = numberOfRatings > 0 ? totalRatings / numberOfRatings : 0;
    return averageRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;

            data = data.sortedBy((a, b) =>
                b['p_wishlist'].length.compareTo(a['p_wishlist'].length));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(
                          context,
                          title: products,
                          count: "${data.length}",
                          icon: icProducts,
                        ),
                        dashboardButton(
                          context,
                          title: orders,
                          count: orderLength,
                          icon: icOrders,
                        ),
                      ],
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(
                          context,
                          title: rating,
                          count: "($averageRating/5.0)",
                          icon: icStar,
                        ),
                        dashboardButton(
                          context,
                          title: totalSales,
                          count: "Rs.$totalsales",
                          icon: icOrders,
                        ),
                      ],
                    ),
                    10.heightBox,
                    const Divider(),
                    10.heightBox,
                    boldText(text: popular, color: fontGrey, size: 16.0),
                    20.heightBox,
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        data.length,
                        (index) => data[index]['p_wishlist'].length == 0
                            ? const SizedBox()
                            : Card(
                                child: ListTile(
                                  onTap: () {
                                    Get.to(() =>
                                        ProductDetails(data: data[index]));
                                  },
                                  leading: Image.network(
                                    data[index]['p_imgs'][0],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                  title: boldText(
                                    text: "${data[index]['p_name']}",
                                    color: fontGrey,
                                  ),
                                  subtitle: normalText(
                                    text: "Rs. ${data[index]['p_price']}",
                                    color: orange,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
