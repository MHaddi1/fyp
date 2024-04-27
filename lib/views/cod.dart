import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/views/congratulation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CODPage extends StatelessWidget {
  const CODPage({Key? key, required this.order, this.index, this.snapshot})
      : super(key: key);
  final Map<String, dynamic> order;
  final dynamic index;
  final dynamic snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Details',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildOrderInfoRow('Price', order['price'].toString()),
              _buildOrderInfoRow('Price Type', order['priceType'].toString()),
              _buildOrderInfoRow('Delivery', order['delivery'].toString()),
              _buildOrderInfoRow('Total Price', order['totalPrice'].toString()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Text(
                  'Confirm Order',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Order"),
          content: Text("Are you sure you want to confirm this order?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform action on cancel
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                double currentPrice = order['price'];
                double deliveryPrice = 200;
                double updatedPrice = currentPrice + deliveryPrice;
                order['totalPrice'] = updatedPrice;
                order['delivery'] = deliveryPrice;
                order['Order Placed'] = true;
                order['deliveryType'] = 'Cash on Delivery';
                order['deliveryStatus'] = 'Work';
                FirebaseFirestore.instance
                    .collection("Orders")
                    .doc(snapshot)
                    .update(order)
                    .then((value) async {
                  final deviceToken =
                      await getToken(FirebaseAuth.instance.currentUser!.email!);
                  print(order['tailorEmail']);
                  print(deviceToken);
                  // Send notification to tailor
                  sendNotification(
                      deviceToken!, 'Order placed!', order['tailorEmail']);

                  // Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Order is being processed for delivery. Total amount with delivery charges: $updatedPrice',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  );
                }).catchError((error) {
                  print("Failed to update document: $error");
                });
                Get.back();
                Get.to(() => Cong());
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
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
