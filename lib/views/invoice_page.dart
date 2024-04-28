import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InvoiceView(
        customerEmail: 'example@example.com',
        trackIdNo: '123456',
        amount: '100',
        delivery: '10',
        total: '110',
      ),
    );
  }
}

class InvoiceView extends StatefulWidget {
  final String trackIdNo;
  final String amount;
  final String delivery;
  final String total;
  final String customerEmail;

  InvoiceView({
    Key? key,
    required this.customerEmail,
    required this.trackIdNo,
    required this.amount,
    required this.delivery,
    required this.total,
  }) : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final _controller = ScreenshotController();
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  saveToGallary() {
    _controller.capture().then((Uint8List? image) {
      saveScreenShoot(image!);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Image save in Gallary!"),
    ));
  }

  saveScreenShoot(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", "-")
        .replaceAll(":", "-");
    final name = 'ScreenShoot$time';
    await ImageGallerySaver.saveImage(name: name, bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      appBar: AppBar(
        title: Text('Invoice'),
        //backgroundColor: Colors.blueAccent,
      ),
      body: Screenshot(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildItemList(),
              Divider(),
              _buildTotal(),
              // SizedBox(height: 20),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Placeholder action for downloading PDF
              //       print('Downloading PDF');
              //     },
              //     child: Text('Download PDF'),
              //   ),
              // ),
              Center(child: _buuton())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track No: ${widget.trackIdNo}',
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold, color: textWhite),
        ),
        SizedBox(height: 10),
        Text(
          'Customer: ${widget.customerEmail}',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildItemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items:',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold, color: textWhite),
        ),
        SizedBox(height: 10),
        _buildItem('Amount: ', widget.amount.toString()),
        _buildItem('Delivery: ', widget.delivery.toString()),
        _buildItem('Currency: ', "PKR"),
        _buildItem('Delivery Charges: ', "200"),
      ],
    );
  }

  Widget _buildItem(String name, String price) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(fontSize: 18, color: textWhite),
          ),
          Text(
            '$price',
            style: GoogleFonts.poppins(fontSize: 18, color: textWhite),
          ),
        ],
      ),
    );
  }

  Widget _buuton() {
    return MyButton(
      width: 70,
      text: "Save",
      onPressed: () async {
        saveToGallary();
        // final image = await _controller.captureFromWidget(
        //     InvoiceView(
        //         customerEmail: widget.customerEmail,
        //         trackIdNo: widget.trackIdNo,
        //         amount: widget.amount,
        //         delivery: widget.delivery,
        //         total: widget.total),
        //     pixelRatio: 2);
        // Share.shareXFiles([
        //   XFile.fromData(image, mimeType: "png"),
        // ]);
      },
    );
  }

  Widget _buildTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Total: ',
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold, color: textWhite),
        ),
        SizedBox(height: 10),
        Text(
          '${widget.total}',
          style: GoogleFonts.poppins(
            height: 2.0,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: mainColor,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.solid,
            decorationColor: mainColor,
          ),
        ),
      ],
    );
  }
}
