import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: textWhite.withOpacity(0.8)),
                  child: Text(
                    "No Internet connection",
                    style: TextStyle(fontSize: 25),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
