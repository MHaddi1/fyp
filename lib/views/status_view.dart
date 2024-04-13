import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:order_tracker/order_tracker.dart';

// enum Status {
//   order,
//   shipped,
//   outForDelivery,
//   delivered,
// }

class StatusView extends StatefulWidget {
  final String check;
  final String delivery;
  final String outForDelivery;
  final String delivered;

  const StatusView({
    Key? key,
    required this.check,
    required this.delivery,
    required this.outForDelivery,
    required this.delivered,
  }) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  // Status getStatus() {
  //   if (widget.check == "Accept") {
  //     if (widget.delivery == "Processing") {
  //       return Status.shipped;
  //     } else if (widget.outForDelivery == "OutForDelivery") {
  //       return Status.outForDelivery;
  //     } else {
  //       return Status.delivered;
  //     }
  //   } else {
  //     return Status.order;
  //   }
  //}

  // String getAnimationPath(Status status) {
  //   switch (status) {
  //     case Status.order:
  //       return "assets/animation/order.json";
  //     case Status.shipped:
  //       return "assets/animation/shipped.json";
  //     case Status.outForDelivery:
  //       return "assets/animation/out_for_delivery.json";
  //     case Status.delivered:
  //       return "assets/animation/delivered.json";
  //   }
  // }

  // String getStatusText(Status status) {
  //   switch (status) {
  //     case Status.order:
  //       return "Order Placed";
  //     case Status.shipped:
  //       return "Order Shipped";
  //     case Status.outForDelivery:
  //       return "Out for Delivery";
  //     case Status.delivered:
  //       return "Order Delivered";
  //   }
  // }

  // Color getStatusColor(Status status) {
  //   switch (status) {
  //     case Status.order:
  //       return Colors.orange;
  //     case Status.shipped:
  //       return Colors.blue;
  //     case Status.outForDelivery:
  //       return Colors.yellow;
  //     case Status.delivered:
  //       return Colors.green;
  //   }
  // }

  List<TextDto> orderList = [
    TextDto("Your order has been placed", ""),
    // TextDto("Seller ha processed your order", ""),
    // TextDto("Your item has been picked up by courier partner.", ""),
  ];

  List<TextDto> shippedList = [
    TextDto("Your order has been shipped", ""),
    //TextDto("Your item has been received in the nearest hub to you.", ""),
  ];

  List<TextDto> outOfDeliveryList = [
    TextDto("Your order is out for delivery", ""),
  ];

  List<TextDto> deliveredList = [
    TextDto("Your order has been delivered", ""),
  ];

  @override
  Widget build(BuildContext context) {
    //Status status = getStatus();
    return Scaffold(
      backgroundColor: Colors.white, // Change background color if needed
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text('Delivery Status'),
          backgroundColor: mainColor // Change app bar color if needed
          ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: 20),
                // Lottie.asset(
                //   getAnimationPath(status),
                //   height: 200, //
                //   width: 200, // Adjust width as needed
                //   animate: true,
                // ),
                SizedBox(height: 20),
                // Text(
                //   getStatusText(status),
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: getStatusColor(status),
                //   ),
                // ),
                if (widget.check == 'Decline')
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(12.0)),
                    padding: const EdgeInsets.all(30.0),
                    child: Center(child: Text("No Status Found")),
                  ),
                if (widget.check == 'Accept')
                  OrderTracker(
                    status: Status.order,
                    activeColor: mainColor,
                    inActiveColor: Colors.grey[300],
                    orderTitleAndDateList: orderList,
                    shippedTitleAndDateList: shippedList,
                    outOfDeliveryTitleAndDateList: outOfDeliveryList,
                    deliveredTitleAndDateList: deliveredList,
                  ),
                if (widget.check == 'Processing')
                  OrderTracker(
                    status: Status.shipped,
                    activeColor: mainColor,
                    inActiveColor: Colors.grey[300],
                    orderTitleAndDateList: orderList,
                    shippedTitleAndDateList: shippedList,
                    outOfDeliveryTitleAndDateList: outOfDeliveryList,
                    deliveredTitleAndDateList: deliveredList,
                  ),

                if (widget.check == 'OutForDelivery')
                  OrderTracker(
                    status: Status.outOfDelivery,
                    activeColor: mainColor,
                    inActiveColor: Colors.grey[300],
                    orderTitleAndDateList: orderList,
                    shippedTitleAndDateList: shippedList,
                    outOfDeliveryTitleAndDateList: outOfDeliveryList,
                    deliveredTitleAndDateList: deliveredList,
                  ),

                if (widget.check == 'delivered')
                  OrderTracker(
                    status: Status.delivered,
                    activeColor: mainColor,
                    inActiveColor: Colors.grey[300],
                    orderTitleAndDateList: orderList,
                    shippedTitleAndDateList: shippedList,
                    outOfDeliveryTitleAndDateList: outOfDeliveryList,
                    deliveredTitleAndDateList: deliveredList,
                  ),
                // OrderTracker(
                //   status: widget.check == "Accept"
                //       ? widget.delivery == "Processing"
                //           ? widget.outForDelivery == "OutForDelivery"
                //               ? widget.delivered == "delivered"
                //                   ? Status.delivered
                //                   : Status.outOfDelivery
                //               : Status.outOfDelivery
                //           : Status.shipped
                //       : Status.order,
                //   activeColor: mainColor,
                //   inActiveColor: Colors.grey[300],
                //   orderTitleAndDateList: orderList,
                //   shippedTitleAndDateList: shippedList,
                //   outOfDeliveryTitleAndDateList: outOfDeliveryList,
                //   deliveredTitleAndDateList: deliveredList,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
