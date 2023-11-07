import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:fyp/views/home/screens/search_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/SharedPrefernece/shared_preference.dart';
import 'screens/home_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      bottomNavigationBar: BottomNavigationBar(
        //enableFeedback: true,
        //elevation: 20,
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
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
