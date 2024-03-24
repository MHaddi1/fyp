import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        //backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
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
          ],
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Customer: ${widget.customerEmail}',
          style: TextStyle(fontSize: 18, color: Colors.grey),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '$price',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Total: ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          '${widget.total}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
