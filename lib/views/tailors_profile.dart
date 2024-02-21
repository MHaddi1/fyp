import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:get/get.dart';

class TailorsProfile extends StatelessWidget {
  const TailorsProfile({
    super.key,
    this.image = "",
    this.description = "",
    this.name = "",
    this.star = 0,
    this.avg = 0.0,
  });

  final String name;
  final String description;
  final int star;
  final String image;
  final double avg;

  @override
  Widget build(BuildContext context) {
    print("name: ${name}");
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        backgroundColor: mainBack,
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
                Container(
                  height: 200,
                  width: Get.width,
                  child: TabBarView(
                    children: [
                      Container(
                        color: mainBack,
                        child: Center(
                          child: Text(
                            'Page 1',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        color: mainBack,
                        child: Center(
                          child: Text(
                            'Page 2',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        color: mainBack,
                        child: Center(
                          child: Text(
                            'Page 3',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          width: 120,
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: textWhite, borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {},
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(image),
                ),
              ),
              Text("Chat")
            ],
          ),
        ),
      ),
    );
  }
}
