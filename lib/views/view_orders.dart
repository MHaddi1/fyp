import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/controllers/order_controllers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ViewOrders extends StatefulWidget {
  final String uid;
  const ViewOrders({super.key, required this.uid});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  final _controller = Get.put(OrdersController());
  Future<String?> getCustomerEmail(String orderId) async {
    try {
      // Initialize Firebase if not already initialized
      await Firebase.initializeApp();

      // Get a reference to the "Orders" collection
      CollectionReference ordersCollection =
          FirebaseFirestore.instance.collection('Orders');

      // Query the collection to get the specific order document
      DocumentSnapshot orderSnapshot =
          await ordersCollection.doc(orderId).get();

      // Check if the document exists
      if (orderSnapshot.exists) {
        // Access the data in the document and retrieve the customer email
        Map<String, dynamic> data =
            orderSnapshot.data() as Map<String, dynamic>;
        String? customerEmail = data['customerEmail'];

        // Return the customer email
        return customerEmail;
      } else {
        // Document does not exist
        print('Document does not exist');
        return null;
      }
    } catch (error) {
      print('Error retrieving customer email: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: Get.height,
                  padding: const EdgeInsets.all(10.0),
                  //padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: textWhite,
                      //borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset: Offset(0, 1),
                        )
                      ]),
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("Orders")
                              .where('tailorEmail',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error With Fetching Data"),
                              );
                            } else {
                              final ordersSnapshot = snapshot.data;

                              if (ordersSnapshot == null ||
                                  ordersSnapshot.docs.isEmpty) {
                                return Center(child: Text('No orders found'));
                              }

                              return ListView.builder(
                                itemCount: ordersSnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  final order =
                                      ordersSnapshot.docs[index].data();
                                  final customerEmail =
                                      order['customerEmail'] ?? '';
                                  final TailorEmail =
                                      order['tailorEmail'] ?? '';
                                  final images = order['images'] ?? [];
                                  final price = order['price'] as double;

                                  return order['deliveryType'] ==
                                          "Cash on Delivery"
                                      ? Container(
                                          margin: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              color: textWhite,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 1.2,
                                                    blurRadius: 2.0,
                                                    blurStyle: BlurStyle.solid,
                                                    offset: Offset(0, 2.0))
                                              ]),
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Order ${index + 1}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: mainColor,
                                                              fontSize: 18),
                                                    ),
                                                    Text(
                                                      '${price.toString()} ${order['priceType']}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color: mainColor),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Customer: $customerEmail',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  'Tailor: ${TailorEmail ?? "No Tailor Found"}',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                if (images.isNotEmpty)
                                                  SizedBox(
                                                    height:
                                                        120.0, // Change here
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: images
                                                            .map<Widget>(
                                                                (image) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: image,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                SizedBox(height: 16),
                                                // order['Order Placed']
                                                //     ? Container()
                                                //     : DropdownButton<String>(
                                                //   value: _paymentMethod,
                                                //   onChanged: (String? newValue) {
                                                //     setState(() {
                                                //       _paymentMethod = newValue!;
                                                //     });
                                                //   },
                                                //   items: <String>[
                                                //     'Bank',
                                                //     'Cash on Delivery'
                                                //   ].map<DropdownMenuItem<String>>(
                                                //           (String value) {
                                                //         return DropdownMenuItem<String>(
                                                //           value: value,
                                                //           child: Text(
                                                //             value,
                                                //             style: GoogleFonts.poppins(color: Colors.blue),
                                                //           ),
                                                //         );
                                                //       }).toList(),
                                                // ),
                                                SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      // order['orderConfirm'] ==
                                                      //         'Accept'
                                                      //     ? MainAxisAlignment
                                                      //         .start
                                                      //     :
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // order['Order Placed']
                                                    //     ? Container()
                                                    //     : ElevatedButton(
                                                    //         onPressed: () {
                                                    //           // if (_paymentMethod == 'Bank') {
                                                    //           //   ScaffoldMessenger.of(context)
                                                    //           //       .showSnackBar(
                                                    //           //     SnackBar(
                                                    //           //       content: Text(
                                                    //           //           'Bank payment option is currently being worked on.'),
                                                    //           //     ),
                                                    //           //   );
                                                    //           // } else if (_paymentMethod ==
                                                    //           //     'Cash on Delivery') {
                                                    //           //   double currentPrice = price;
                                                    //           //   double deliveryPrice = 200;
                                                    //           //   double updatedPrice =
                                                    //           //       currentPrice + deliveryPrice;
                                                    //           //   print(
                                                    //           //       'Total price with delivery charges: $updatedPrice');

                                                    //           //   order['totalPrice'] = updatedPrice;
                                                    //           //   order['delivery'] = deliveryPrice;
                                                    //           //   order['Order Placed'] = true;
                                                    //           //   order['deliveryType'] =
                                                    //           //   'Cash on Delivery';
                                                    //           //   order['deliveryStatus'] =
                                                    //           //   'Processing';

                                                    //           //   FirebaseFirestore.instance
                                                    //           //       .collection("Orders")
                                                    //           //       .doc(
                                                    //           //       ordersSnapshot.docs[index].id)
                                                    //           //       .update(order)
                                                    //           //       .then((value) async{
                                                    //           //         final deviceToken = await getToken(FirebaseAuth.instance.currentUser!.email!);
                                                    //           //         print( order['tailorEmail']);
                                                    //           //         print(deviceToken);
                                                    //           //     // Send notification to tailor
                                                    //           //     sendNotification(
                                                    //           //         deviceToken!,
                                                    //           //         'Order placed!',
                                                    //           //         order['tailorEmail']);

                                                    //           //     // Show a confirmation message
                                                    //           //     ScaffoldMessenger.of(context)
                                                    //           //         .showSnackBar(
                                                    //           //       SnackBar(
                                                    //           //         content: Text(
                                                    //           //           'Order is being processed for delivery. Total amount with delivery charges: $updatedPrice',
                                                    //           //           style: GoogleFonts.poppins(
                                                    //           //               color: Colors.white),
                                                    //           //         ),
                                                    //           //       ),
                                                    //           //     );
                                                    //           //   }).catchError((error) {
                                                    //           //     print(
                                                    //           //         "Failed to update document: $error");
                                                    //           //   });
                                                    //           // }
                                                    //         },
                                                    //         child: Text(
                                                    //           'Pay',
                                                    //           style: GoogleFonts.poppins(
                                                    //               color:
                                                    //                   Colors.white),
                                                    //         ),
                                                    //         style: ButtonStyle(
                                                    //           backgroundColor:
                                                    //               MaterialStateProperty
                                                    //                   .all<Color>(
                                                    //                       Colors
                                                    //                           .green),
                                                    //         ),
                                                    //       ),
                                                    if (order["orderConfirm"] ==
                                                        "Decline")
                                                      Container(),
                                                    if (order["orderConfirm"] ==
                                                        "No")
                                                      Obx(
                                                        () => DropdownButton<
                                                            String>(
                                                          value: _controller
                                                              .dropdownValue
                                                              .value,
                                                          icon: Icon(Icons
                                                              .arrow_downward),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color:
                                                                      mainColor),
                                                          underline: Container(
                                                            height: 2,
                                                            color: mainColor,
                                                          ),
                                                          onChanged:
                                                              (newValue) {
                                                            _controller
                                                                .changeValue(
                                                                    newValue!);
                                                            print(_controller
                                                                .dropdownValue
                                                                .value);
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Orders")
                                                                .doc(ordersSnapshot
                                                                    .docs[index]
                                                                    .id)
                                                                .set(
                                                                    {
                                                                  "orderConfirm":
                                                                      _controller
                                                                          .dropdownValue
                                                                          .value
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                            // final message = ;
                                                            Future.delayed(
                                                                Duration(
                                                                    seconds:
                                                                        10),
                                                                () {
                                                              sendNotification(
                                                                  "deviceToken",
                                                                  order["orderConfirm"] !=
                                                                          "Accept"
                                                                      ? "Tailor is Working"
                                                                      : "🤯 Sorry Tailor is Busy Right Now!!",
                                                                  customerEmail);
                                                            });
                                                          },
                                                          items: <String>[
                                                            'Accept',
                                                            'Decline'
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),

                                                    if (order["orderConfirm"] ==
                                                        "Accept")
                                                      Obx(
                                                        () => DropdownButton<
                                                            String>(
                                                          value: _controller
                                                              .dropdownValue2
                                                              .value,
                                                          icon: Icon(Icons
                                                              .arrow_downward),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color:
                                                                      mainColor),
                                                          underline: Container(
                                                            height: 2,
                                                            color: mainColor,
                                                          ),
                                                          onChanged:
                                                              (newValue) {
                                                            _controller
                                                                .changeValue2(
                                                                    newValue!);
                                                            print(_controller
                                                                .dropdownValue2
                                                                .value);
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Orders")
                                                                .doc(ordersSnapshot
                                                                    .docs[index]
                                                                    .id)
                                                                .set(
                                                                    {
                                                                  "deliveryStatus":
                                                                      "Processing",
                                                                  "orderConfirm":
                                                                      "Processing"
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                            // final message = ;
                                                            Future.delayed(
                                                                Duration(
                                                                    seconds:
                                                                        10),
                                                                () {
                                                              sendNotification(
                                                                  "deviceToken",
                                                                  "Status Check",
                                                                  customerEmail);
                                                            });
                                                          },
                                                          items: <String>[
                                                            'Shipped',
                                                            // 'Decline'
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),

                                                    //OutForDelivery
                                                    if (order["orderConfirm"] ==
                                                        "Processing")
                                                      Obx(
                                                        () => DropdownButton<
                                                            String>(
                                                          value: _controller
                                                              .dropdownValue3
                                                              .value,
                                                          icon: Icon(Icons
                                                              .arrow_downward),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color:
                                                                      mainColor),
                                                          underline: Container(
                                                            height: 2,
                                                            color: mainColor,
                                                          ),
                                                          onChanged:
                                                              (newValue) {
                                                            _controller
                                                                .changeValue3(
                                                                    newValue!);
                                                            print(_controller
                                                                .dropdownValue3
                                                                .value);
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Orders")
                                                                .doc(ordersSnapshot
                                                                    .docs[index]
                                                                    .id)
                                                                .set(
                                                                    {
                                                                  "OutForDelivery":
                                                                      "OutForDelivery",
                                                                  "orderConfirm":
                                                                      "OutForDelivery"
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                            // final message = ;
                                                            Future.delayed(
                                                                Duration(
                                                                    seconds:
                                                                        10),
                                                                () {
                                                              sendNotification(
                                                                  "deviceToken",
                                                                  "Status Check",
                                                                  customerEmail);
                                                            });
                                                          },
                                                          items: <String>[
                                                            'OutForDelivery',
                                                            // 'Decline'
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),

                                                    //delivered
                                                    if (order["orderConfirm"] ==
                                                        "OutForDelivery")
                                                      Obx(
                                                        () => DropdownButton<
                                                            String>(
                                                          value: _controller
                                                              .dropdownValue4
                                                              .value,
                                                          icon: Icon(Icons
                                                              .arrow_downward),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color:
                                                                      mainColor),
                                                          underline: Container(
                                                            height: 2,
                                                            color: mainColor,
                                                          ),
                                                          onChanged:
                                                              (newValue) {
                                                            _controller
                                                                .changeValue4(
                                                                    newValue!);
                                                            print(_controller
                                                                .dropdownValue4
                                                                .value);
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Orders")
                                                                .doc(ordersSnapshot
                                                                    .docs[index]
                                                                    .id)
                                                                .set(
                                                                    {
                                                                  "delivered":
                                                                      "delivered",
                                                                  'orderConfirm':
                                                                      'delivered'
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                            // final message = ;
                                                            Future.delayed(
                                                                Duration(
                                                                    seconds:
                                                                        10),
                                                                () {
                                                              sendNotification(
                                                                  "deviceToken",
                                                                  "Status Check",
                                                                  customerEmail);
                                                            });
                                                          },
                                                          items: <String>[
                                                            'delivered',

                                                            // 'Decline'
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    if (order['orderConfirm'] ==
                                                        'delivered')
                                                      Container(),
                                                    // MyButton(
                                                    //   width: 100,
                                                    //   text: "Confirm Orders",
                                                    //   onPressed: () {

                                                    //   },
                                                    // )
                                                    // order["Order Placed"]
                                                    //     ? MyButton(
                                                    //         text: "Status",
                                                    //         width: 90,
                                                    //         height: 36,
                                                    //         onPressed: () {},
                                                    //       )
                                                    //     : Container(),
                                                    Text(
                                                      order["Order Placed"]
                                                          ? "Accepted"
                                                          : "Accept or Decline",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            order['orderConfirm'] ==
                                                                    'Decline'
                                                                ? Colors.red
                                                                : Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container();
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
