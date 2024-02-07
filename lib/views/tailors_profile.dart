import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';

class TailorsProfile extends StatelessWidget {
  const TailorsProfile(
      {super.key,
      required this.image,
      this.description = "",
      this.name = "",
      required this.star,
      this.avg = 0.0});

  final String name;
  final String description;
  final int star;
  final String image;
  final double avg;

  @override
  Widget build(BuildContext context) {
    print("name: ${name}");
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                color: mainBack,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(image),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'username',
                      style: TextStyle(color: textWhite),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: textWhite,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    Text(
                      "Total Rating: ${star.toString()} ⭐",
                      style: TextStyle(color: textWhite, fontSize: 25),
                    ),
                    Text(
                      "⭐ ${avg}",
                      style: TextStyle(fontSize: 25.0, color: textWhite),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description:",
                              style:
                                  TextStyle(color: textWhite, fontSize: 30.0),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              description,
                              style:
                                  TextStyle(color: textWhite, fontSize: 17.0),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
