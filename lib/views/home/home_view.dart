import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:fyp/views/home/screens/search_screen.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () => _onBackButtonPressed(context),
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: Container(
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: GNav(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                activeColor: Colors.orange,
                tabBackgroundColor: Colors.white,
                gap: 8,
                backgroundColor: Colors.orange,
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: "Home",
                  ),
                  GButton(
                    icon: Icons.search,
                    text: "Search",
                  ),
                  GButton(
                    icon: Icons.person,
                    text: "Profile",
                  )
                ]),
          ),
        ));
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
