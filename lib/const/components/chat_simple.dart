import 'package:flutter/material.dart';
import 'package:fyp/const/components/chat_persons.dart';
import 'package:fyp/views/chat_view.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatSimple extends StatelessWidget {
  final String username;
  final String? message;
  final void Function()? onPressed;
  const ChatSimple(
      {super.key, this.message, required this.username, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onPressed,
        leading: Icon(Icons.person),
        title: Text(username),
      ),
    );
  }
}
