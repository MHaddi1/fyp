import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:http/http.dart' as http;

import '../const/color.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  String _paymentMethod = 'Bank'; // Default payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: mainColor, // Customize app bar color
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where('customerEmail',
              isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error With Fetching Data"),
              );
            } else {
              final ordersSnapshot = snapshot.data;

              if (ordersSnapshot == null || ordersSnapshot.docs.isEmpty) {
                return Center(child: Text('No orders found'));
              }

              return ListView.builder(
                itemCount: ordersSnapshot.docs.length,
                itemBuilder: (context, index) {
                  final order = ordersSnapshot.docs[index].data();
                  final customerEmail = order['customerEmail'] ?? '';
                  final TailorEmail = order['customerEmail'] ?? '';
                  final images = order['images'] ?? [];
                  final price = order['price'] as double;

                  return Card(
                    elevation: 4,
                    color: Colors.white,
                    margin: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order ${index + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: mainColor,
                                    fontSize: 18),
                              ),
                              Text(
                                '${price.toString()} ${order['priceType']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: mainColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Customer: $customerEmail',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            'Tailor: ${TailorEmail ?? "No Tailor Found"}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          if (images.isNotEmpty)
                            SizedBox(
                              height: 120.0, // Change here
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: images.map<Widget>((image) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          SizedBox(height: 16),
                          order['Order Placed']
                              ? Container()
                              : DropdownButton<String>(
                            value: _paymentMethod,
                            onChanged: (String? newValue) {
                              setState(() {
                                _paymentMethod = newValue!;
                              });
                            },
                            items: <String>[
                              'Bank',
                              'Cash on Delivery'
                            ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  );
                                }).toList(),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              order['Order Placed']
                                  ? Container()
                                  : ElevatedButton(
                                onPressed: () {
                                  if (_paymentMethod == 'Bank') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Bank payment option is currently being worked on.'),
                                      ),
                                    );
                                  } else if (_paymentMethod ==
                                      'Cash on Delivery') {
                                    double currentPrice = price;
                                    double deliveryPrice = 200;
                                    double updatedPrice =
                                        currentPrice + deliveryPrice;
                                    print(
                                        'Total price with delivery charges: $updatedPrice');

                                    order['totalPrice'] = updatedPrice;
                                    order['delivery'] = deliveryPrice;
                                    order['Order Placed'] = true;
                                    order['deliveryType'] =
                                    'Cash on Delivery';
                                    order['deliveryStatus'] =
                                    'Processing';

                                    FirebaseFirestore.instance
                                        .collection("Orders")
                                        .doc(
                                        ordersSnapshot.docs[index].id)
                                        .update(order)
                                        .then((value) async{
                                          final deviceToken = await getToken(FirebaseAuth.instance.currentUser!.email!);
                                          print( order['tailorEmail']);
                                          print(deviceToken);
                                      // Send notification to tailor
                                      sendNotification(
                                          deviceToken!,
                                          'Order placed!',
                                          order['tailorEmail']);

                                      // Show a confirmation message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Order is being processed for delivery. Total amount with delivery charges: $updatedPrice',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }).catchError((error) {
                                      print(
                                          "Failed to update document: $error");
                                    });
                                  }
                                },
                                child: Text(
                                  'Pay',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.green),
                                ),
                              ),
                              order["Order Placed"]
                                  ? MyButton(
                                text: "Status",
                                width: 90,
                                height: 36,
                                onPressed: () {},
                              )
                                  : Container(),
                              Text(
                                order["Order Placed"]
                                    ? order["Yes"]
                                    : order["NO"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: order["Order Placed"]
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<String?> getToken(String email) async {
    try {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(email).get();

      if (userSnapshot.exists) {
        return userSnapshot.get('FCMToken');
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }

  void sendNotification(
      String deviceToken, String message, String email) async {
    final tailorToken = await getToken(email);

    var data = {
      "to": tailorToken ?? deviceToken,
      "priority": "high",
      'notification': {
        "title": tailorToken == null ? "You send Message" : "New Message",
        "body": message,
      },
      "data": {'type': "order", "id": "123456"}
    };

    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization":
          "key=AAAANFZ7kDQ:APA91bFzd7VOzBXrRAd7B6l2PN5UEZv1NtXQR3QUqed2M32zYf4mLyppR5P9dzg9nid8pOGhKeVIsunwtJUDkye13ow4zQu8abSNdgYb_Ah29UVxZxPK5La37oQNF-226d8nmCDSL6Y3"
        },
        body: jsonEncode(data),
      );
    } catch (error) {
      print("Error sending notification: $error");
    }
  }
}
