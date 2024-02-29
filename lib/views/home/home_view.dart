// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/drawer.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/services/notification_services.dart';
import 'package:fyp/views/home/screens/home_screen.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:fyp/views/home/screens/search_screen.dart';
import 'package:fyp/views/message_user_list.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize notification services
    MessageNotification().requestNotificationPremission();
    MessageNotification().firebaseInit(context);
    MessageNotification().isTokenRefreshed();
    MessageNotification().setupInteractMessage(context);
    MessageNotification().getMessageTokken().then((value) {
      print("Token $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      appBar: AppBar(
        centerTitle: true,
        title: Text('title'.tr),
        actions: [
          IconButton(
            onPressed: () async {
              Get.to(() => MessageList());
            },
            icon: const Icon(Icons.chat_bubble),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: _screens[_currentIndex],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Are you sure you want to exit?"),
          actions: <Widget>[
            MyButton(
              text: "NO",
              onPressed: () {
                Get.back(result: false);
              },
            ),
            10.heightBox,
            MyButton(
              text: "Yes",
              onPressed: () {
                Get.back(result: true);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            )
          ],
        );
      },
    );

    return exitApp;
  }
}
