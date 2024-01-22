import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {super.key,
      required this.image,
      required this.desctiption,
      required this.name,
      required this.onPressed,
      this.avg = 0.0});
  final String image;
  final String name;
  final String desctiption;
  final Function() onPressed;
  final double avg;

  @override
  Widget build(BuildContext context) {
    print("ProfileCard Build");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: postBlock, borderRadius: BorderRadius.circular(12.0)),
        child: ListTile(
          leading: Container(
            width: 60.0,
            height: 60.0,
            child: ClipOval(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(color: textWhite),
          ),
          subtitle: Text(
            "${desctiption} ⭐ ${avg}",
            style: TextStyle(color: Colors.grey),
          ),
          trailing: ElevatedButton(
            onPressed: onPressed,
            child: Text("Visit"),
          ),
        ),
      ),
    );
  }
}
