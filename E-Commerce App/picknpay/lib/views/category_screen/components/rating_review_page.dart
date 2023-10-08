import 'package:get/get.dart';
import 'package:picknpay/consts/consts.dart';
import 'package:picknpay/controller/product_controller.dart';
import 'package:picknpay/services/firestore_services.dart';

class RatingReviewPage extends StatefulWidget {
  final String productid;
  const RatingReviewPage({super.key, required this.productid});

  @override
  RatingReviewPageState createState() => RatingReviewPageState();
}

class RatingReviewPageState extends State<RatingReviewPage> {
  var controller = Get.put(ProductController());

  final TextEditingController reviewController = TextEditingController();
  int rating = 0;

  void onRatingChanged(int newRating) {
    setState(() {
      rating = newRating;
    });
  }

  void submitRatingAndReview() {
    // Get the review text from the text controller
    String reviewText = reviewController.text.trim();

    // Validate if the user has provided both a rating and a review
    if (rating > 0 && reviewText.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thank You!'),
            content: const Text('Rating and review submitted successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await controller.addRatingReview(
                    rating: rating,
                    review: reviewText,
                    context: context,
                    productId: widget.productid,
                  );
                  setState(() {
                    rating = 0;
                    reviewController.clear();
                  });
                  await FirestoreServices.uploadProductRating(widget.productid);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide both a rating and a review.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'Rate and Review Product',
          style: TextStyle(fontFamily: semibold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Rate the Product:'),
            const SizedBox(height: 10),
            // Star rating widget
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => onRatingChanged(index + 1),
                  child: Icon(
                    Icons.star,
                    size: 40,
                    color: rating > index ? Colors.amber : Colors.grey[400],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('Write Your Review:'),
            const SizedBox(height: 10),
            // Review input field
            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your review here...',
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Submit button
            ElevatedButton(
              onPressed: () async {
                bool userHasReviewed = await controller.hasUserReviewedProduct(
                    productId: widget.productid);

                if (userHasReviewed) {
                  setState(() {
                    rating = 0;
                    reviewController.clear();
                  });
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("You have already reviewed this product.")));
                } else {
                  submitRatingAndReview();
                }
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(redColor),
              ),
              child: const Text('Submit'),
            ),
            10.heightBox,
          ],
        ),
      ),
    );
  }
}
