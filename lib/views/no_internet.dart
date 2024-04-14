import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset("assets/image/connection_lost.json",
                  width: media.width * 0.4),
              SizedBox(
                height: media.height * 0.06,
              ),
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
