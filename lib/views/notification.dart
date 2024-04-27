import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationS extends StatefulWidget {
  const NotificationS({super.key});

  @override
  State<NotificationS> createState() => _NotificationSState();
}

class _NotificationSState extends State<NotificationS> {
  var docs = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notification"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where('tailorEmail',
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
                return Center(child: Text('No Notification found'));
              }

              return ListView.builder(
                itemCount: ordersSnapshot.docs.length,
                itemBuilder: (context, index) {
                  final order =

                      /// The code is retrieving the data of a document at a specific index
                      /// from a collection snapshot in Dart.
                      ordersSnapshot.docs[index].data();
                  final customerEmail = order['customerEmail'] ?? '';
                  final TailorEmail = order['tailorEmail'] ?? '';
                  final images = order['images'] ?? [];
                  final price = order['price'] as double;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: order['isRead'] ? textWhite : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              trailing: InkWell(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("Orders")
                                        .doc(ordersSnapshot.docs[index].id)
                                        .set({"isRead": true},
                                            SetOptions(merge: true));
                                  },
                                  child: Text("Mark Read")),

                              // IconButton(
                              //     onPressed: () {

                              //       showMenu(
                              //         context: context,
                              //         position: RelativeRect.fromLTRB(
                              //           MediaQuery.of(context).size.width -
                              //               100, // Adjust the x-coordinate to shift the menu to the right
                              //           // MediaQuery.of(context).size.height +
                              //           100, // Adjust the y-coordinate as needed
                              //           0,
                              //           0,
                              //         ),
                              //         items: [
                              //           PopupMenuItem(
                              //             child: InkWell(
                              //               onTap: () {

                              //               },
                              //               child: Text("Mark as Read"),
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //     icon: Icon(Icons.more_vert)),
                              title: Text(
                                '${price.toString()} ${order['priceType']}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: mainColor),
                              ),
                              subtitle: Text(
                                  'Customer: $customerEmail\nTailor: ${TailorEmail ?? "No Tailor Found"}'),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 50.0, // Change here
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: images.map<Widget>((image) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Text(
                                "Request ${order['orderConfirm']}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: order['orderConfirm'] == 'Decline'
                                        ? Colors.red
                                        : Colors.green),
                              ),
                            ),
                            // Text(
                            //   'Customer: $customerEmail',
                            //   style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                            // ),
                            // Text(
                            //   'Tailor: ${TailorEmail ?? "No Tailor Found"}',
                            //   style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                            // ),
                            //if (images.isNotEmpty)

                            // SizedBox(height: 16),
                            // order['Order Placed']
                            //     ? Container()
                            //     : DropdownButton<String>(
                            //         value: _paymentMethod,
                            //         onChanged: (String? newValue) {
                            //           setState(() {
                            //             _paymentMethod = newValue!;
                            //           });
                            //         },
                            //         items: <String>[
                            //           'Bank',
                            //           'Cash on Delivery'
                            //         ].map<DropdownMenuItem<String>>(
                            //             (String value) {
                            //           return DropdownMenuItem<
                            //               String>(
                            //             value: value,
                            //             child: Text(
                            //               value,
                            //               style: GoogleFonts.poppins(
                            //                   color: Colors.blue),
                            //             ),
                            //           );
                            //         }).toList(),
                            //       ),
                            SizedBox(height: 16),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     order['Order Placed']
                            //         ? Container()
                            //         : ElevatedButton(
                            //             onPressed: () {
                            //               if (_paymentMethod ==
                            //                   'Bank') {
                            //                 ScaffoldMessenger.of(
                            //                         context)
                            //                     .showSnackBar(
                            //                   SnackBar(
                            //                     content: Text(
                            //                         'Bank payment option is currently being worked on.'),
                            //                   ),
                            //                 );
                            //               } else if (_paymentMethod ==
                            //                   'Cash on Delivery') {
                            //                 double currentPrice =
                            //                     price;
                            //                 double deliveryPrice =
                            //                     200;
                            //                 double updatedPrice =
                            //                     currentPrice +
                            //                         deliveryPrice;
                            //                 print(
                            //                     'Total price with delivery charges: $updatedPrice');

                            //                 order['totalPrice'] =
                            //                     updatedPrice;
                            //                 order['delivery'] =
                            //                     deliveryPrice;
                            //                 order['Order Placed'] =
                            //                     true;
                            //                 order['deliveryType'] =
                            //                     'Cash on Delivery';
                            //                 order['deliveryStatus'] =
                            //                     'Work';

                            //                 FirebaseFirestore
                            //                     .instance
                            //                     .collection(
                            //                         "Orders")
                            //                     .doc(ordersSnapshot
                            //                         .docs[index].id)
                            //                     .update(order)
                            //                     .then(
                            //                         (value) async {
                            //                   // final deviceToken =
                            //                   //     await getToken(
                            //                   //         FirebaseAuth
                            //                   //             .instance
                            //                   //             .currentUser!
                            //                   //             .email!);
                            //                   // print(order[
                            //                   //     'tailorEmail']);
                            //                   // print(deviceToken);
                            //                   // Send notification to tailor
                            //                   // sendNotification(
                            //                   //     deviceToken!,
                            //                   //     'Order placed!',
                            //                   //     order[
                            //                   //         'tailorEmail']);

                            //                   // Show a confirmation message
                            //                   ScaffoldMessenger.of(
                            //                           context)
                            //                       .showSnackBar(
                            //                     SnackBar(
                            //                       content: Text(
                            //                         'Order is being processed for delivery. Total amount with delivery charges: $updatedPrice',
                            //                         style: GoogleFonts.poppins(
                            //                             color: Colors
                            //                                 .white),
                            //                       ),
                            //                     ),
                            //                   );
                            //                 }).catchError((error) {
                            //                   print(
                            //                       "Failed to update document: $error");
                            //                 });
                            //               }
                            //             },
                            //             child: Text(
                            //               'Pay',
                            //               style: GoogleFonts.poppins(
                            //                   color: Colors.white),
                            //             ),
                            //             style: ButtonStyle(
                            //               backgroundColor:
                            //                   MaterialStateProperty
                            //                       .all<Color>(
                            //                           Colors.green),
                            //             ),
                            //           ),
                            //     // order["Order Placed"]
                            //     //     ?
                            //     MyButton(
                            //       text: "Status",
                            //       width: 90,
                            //       height: 36,
                            //       onPressed: () {
                            //         Get.to(() => StatusView(
                            //               check:
                            //                   order["orderConfirm"],
                            //               delivery: order[
                            //                   'deliveryStatus'],
                            //               outForDelivery: order[
                            //                       'outFordelivery'] ??
                            //                   "No",
                            //               delivered:
                            //                   order['delivered'] ??
                            //                       "No",
                            //             ));
                            //       },
                            //     ),
                            //     // : Container(),
                            //     Text(
                            //       order["orderConfirm"] == "Accept"
                            //           ? "Tailor is Working"
                            //           : "Please Wait...",
                            //       style: GoogleFonts.poppins(
                            //         fontWeight: FontWeight.bold,
                            //         color: order["orderConfirm"] ==
                            //                 "Accept"
                            //             ? Colors.green
                            //             : Colors.red,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
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
}
