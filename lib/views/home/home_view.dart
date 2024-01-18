import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/drawer.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/profile_card.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:fyp/views/home/screens/search_screen.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'screens/home_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      drawer: const MyDrawer(),
      body: WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: _screens[_currentIndex],
      ),
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
                  })
            ],
          );
        });

    return exitApp;
  }
}
