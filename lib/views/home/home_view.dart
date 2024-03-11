// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/drawer.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/controllers/login_controller.dart';
import 'package:fyp/services/auth/sign_services.dart';
import 'package:fyp/services/changeProfile.dart';
import 'package:fyp/services/notification_services.dart';
import 'package:fyp/views/home/screens/home_screen.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:fyp/views/home/screens/search_screen.dart';
import 'package:fyp/views/message_user_list.dart';
import 'package:fyp/views/shopping_cart.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? user;
  final check = SignServices();
  bool? userCheck;
  List<String> email = [];
  final changeProfile = ChangeProfile();
  String email2 = "";

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  // call() async {
  //   //email2 = await myCollection();
  //   // await Future.delayed(Duration(seconds: 20), () {
  //     setStatus("Online");
  //   // });
  // }

  // Future myCollection() async {
  //   final lenght = await changeProfile.getMessageUsersLength();
  //   final email = await changeProfile.getUserEmailsFromIndex(lenght);
  //   print(email);
  //   return email;
  // }

  // Future checkCollection() async {
  //   if (user != null) {
  //     // Assuming `checkUserDataExists()` returns a boolean
  //     bool userCheck = await check.checkUserDataExists(user!);
  //
  //     if (userCheck) {
  //       // Assuming `saveUserData()` returns a Future
  //       await check.saveUserData(user!);
  //       // Assuming `call()` is a function defined elsewhere
  //       call();
  //     }
  //   }
  // }
@override
  void dispose() {
  setStatus("Offline");
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    // email2 = await checkCollection();
   // WidgetsBinding.instance.addObserver(this);
   //  call();
setStatus("Online");
    // login.signInWithGoogle(context);

    // Initialize notification servicess
    MessageNotification.instance.requestNotificationPremission();
    MessageNotification.instance.firebaseInit(context);
    MessageNotification.instance.isTokenRefreshed();
    MessageNotification.instance.setupInteractMessage(context);
    MessageNotification.instance.getMessageTokken().then((value) {
      print("Token $value");
     // addToken(value);
    });
  }


  //
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   // final email = await myCollection();
  //   if (state == AppLifecycleState.resumed) {
  //     //online
  //     setStatus("Online");
  //   } else {
  //     //offline
  //     setStatus("Offline");
  //   }
  // }

  void setStatus(String status) async {
    try {
      _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({"status": status}, SetOptions(merge: true));
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final length = Get.arguments;
    return Scaffold(
      backgroundColor: mainBack,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Get.offAll(() => MessageList(id: "123456"));
            },
            icon: const Icon(Icons.chat,),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => ShoppingCart(), arguments: length);
            },
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart), // Icon for the shopping cart
                if (length ?? 0 > 0) // Display badge only if length is greater than 0
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                      ),
                      child: Text(
                        length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

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
