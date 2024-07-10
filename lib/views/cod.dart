import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/views/congratulation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CODPage extends StatefulWidget {
  const CODPage(
      {Key? key,
      required this.order,
      this.index,
      this.snapshot,
      this.deliveryPrice,
      this.updatePrice})
      : super(key: key);
  final Map<String, dynamic> order;
  final dynamic index;
  final dynamic snapshot;
  final dynamic deliveryPrice;
  final dynamic updatePrice;

  @override
  State<CODPage> createState() => _CODPageState();
}

class _CODPageState extends State<CODPage> {
  @override
  void initState() {
    super.initState();
  }

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
              _buildOrderInfoRow('Price', widget.order['price'].toString()),
              _buildOrderInfoRow(
                  'Price Type', widget.order['priceType'].toString()),
              _buildOrderInfoRow('Delivery', widget.deliveryPrice.toString()),
              _buildOrderInfoRow('Total Price', widget.updatePrice.toString()),
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
                widget.order['totalPrice'] = widget.updatePrice;
                widget.order['delivery'] = widget.deliveryPrice;
                widget.order['Order Placed'] = true;
                widget.order['deliveryType'] = 'Cash on Delivery';
                widget.order['deliveryStatus'] = 'Work';
                FirebaseFirestore.instance
                    .collection("Orders")
                    .doc(widget.snapshot)
                    .update(widget.order)
                    .then((value) async {
                  final deviceToken =
                      await getToken(FirebaseAuth.instance.currentUser!.email!);
                  print(widget.order['tailorEmail']);
                  print(deviceToken);

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       'Order is being processed for delivery. Total amount with delivery charges: $updatedPrice',
                  //       style: GoogleFonts.poppins(color: Colors.white),
                  //     ),
                  //   ),
                  // );
                  // Send notification to tailor
                  sendNotification(deviceToken!, 'Order placed!',
                      widget.order['tailorEmail']);

                  // Show a confirmation message
                }).catchError((error) {
                  print("Failed to update document: $error");
                });
                Get.back();
                Get.offAll(() => Cong());
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
