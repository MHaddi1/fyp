import 'package:flutter/material.dart';
import 'package:fyp/views/c_d_payment.dart';
import 'package:fyp/views/cod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, this.order, this.snapshot});

  final dynamic snapshot;
  final dynamic order;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(),
            InkWell(
              onTap: () {
                Get.to(() => CODPage(
                      order: widget.order,
                      snapshot: widget.snapshot,
                    ));
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/image/cod.png",
                    width: 30,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    'Cash on Delivery',
                    style: GoogleFonts.poppins(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Divider(),
            InkWell(
              onTap: () {
                Get.to(() => C_DPayment(
                      amount: widget.order['totalPrice'],
                    ));
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/image/cd.png",
                    width: 30,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    'Credit Card / Dabit Card',
                    style: GoogleFonts.poppins(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
