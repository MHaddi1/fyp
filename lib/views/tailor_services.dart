import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/views/home/home_view.dart';
import 'package:fyp/views/home/screens/home_screen.dart';
import 'package:get/get.dart';

class TailorServices extends StatefulWidget {
  const TailorServices({Key? key, required this.email}) : super(key: key);
  final email;
  @override
  State<TailorServices> createState() => _TailorServicesState();
}

class _TailorServicesState extends State<TailorServices> {
  Map Price = {};

  Future<Map<String, dynamic>?> fetchTailorServices() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Tailor_Services')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        return data;
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching Tailor_Services: $e');
      return null;
    }
  }

  @override
  void initState() {
    fetchTailorServices();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      appBar: AppBar(
        title: Text('Tailor Services'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Tailor_Services')
            .doc(widget.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            if (!data.containsKey('images')) {
              return Center(child: Text('No images found'));
            }

            final imagesData = data['images'] as Map<String, dynamic>;
            final descriptionData =
            data['description'] as Map<String, dynamic>;
            final price = data['priceList'] as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: mainColor, // Set your desired color here
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Service',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var entry in price.entries)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(entry.key),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Rs ${entry.value.toString()}",
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: imagesData.length,
                    itemBuilder: (context, index) {
                      final imageType = imagesData.keys.elementAt(index);
                      final images = imagesData[imageType] as List<dynamic>;
                      final descriptionType =
                      descriptionData.keys.elementAt(index);
                      final description =
                      descriptionData[descriptionType] as String;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: mainColor, // Set your desired color here
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset:
                                Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                            elevation:
                            0, // Set elevation to 0 to remove the shadow of the Card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20.0),
                                  child: Text(
                                    snapshot.data!['title'],
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    imageType,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: images.length,
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: images[i],
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.8,
                                            height: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.8,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    description,
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Define the action when the button is pressed, such as navigating to an order screen.
          // Example:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderScreen(email: widget.email, Price: Price),
            ),
          );
        },
        label: Text('Order Now'),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: mainColor,
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final String email;
  final Map Price;

  const OrderScreen({Key? key, required this.email, required this.Price})
      : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late String PriceType;
  final TextEditingController _priceController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();



  void placeOrder() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> tailorSnapshot =
      await FirebaseFirestore.instance
          .collection('Tailor_Services')
          .doc(widget.email)
          .get();

      if (tailorSnapshot.exists) {
        Map<String, dynamic> tailorData = tailorSnapshot.data()!;
        List<dynamic> images = [];
        Map price = {};

        // Check if the 'images' key exists and if it's a list
        if (tailorData.containsKey('images') && tailorData['images'] is Map) {
          images = tailorData['images']['ServiceImages'];
          if (kDebugMode) {
            print("My Images ${images}");
          }
        }
        if (tailorData.containsKey("priceList") &&
            tailorData['priceList'] is Map) {
          price.addAll(tailorData['priceList']);
          if (kDebugMode) {
            print("My Price ${price}");
          }
        }

        // Match the selected price with the price in the priceList
        double selectedPrice = double.parse(_priceController.text.trim());
        bool priceMatched = false;
        price.forEach((serviceName, price) {
          if (price == selectedPrice) {
            priceMatched = true;
            PriceType = serviceName;
          }
        });

        if (!priceMatched) {
          // If price doesn't match, show snackbar and return
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text('Selected price does not match. Order not placed.'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Create the new order
        // Map<String, dynamic> newOrder = ;

        // Add the new order to Firestore
        await FirebaseFirestore.instance
            .collection('Orders')

            .add({
          'tailorEmail': widget.email,
          'customerEmail': FirebaseAuth.instance.currentUser!.email,
          'images': images, // Use the images list here
          'price': selectedPrice,
          'priceType': PriceType,
          "Order Placed": false,
          "Yes": "ORDER PLACED",
          'NO': "PLACED ORDER FIRST"
        }
        );

        // Get the updated orders list from Firestore
        // DocumentSnapshot<Map<String, dynamic>> updatedOrderSnapshot =
        // await FirebaseFirestore.instance
        //     .collection('Orders')
        //     .doc(widget)
        //     .get();

       // if (updatedOrderSnapshot.exists) {
         // int length =  updatedOrderSnapshot.data()!['orders'].length;
          //print('Length of orders: $length');

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order placed successfully.'),
              duration: Duration(seconds: 3),
            ),
          );



          // Navigate to home screen
          Get.offAll(() => HomeView());
        }
     // }
    } catch (e) {
      print('Error placing order: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: placeOrder,
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
