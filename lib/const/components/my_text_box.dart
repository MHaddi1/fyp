import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String yourName;
  final void Function()? onPressed;

  const MyTextBox({
    Key? key,
    required this.text,
    required this.yourName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text.text.bold.size(16).color(Colors.black).make(),
                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.settings),
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 8),
            yourName.text.size(18).make(),
          ],
        ),
      ),
    );
  }
}
