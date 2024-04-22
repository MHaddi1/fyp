import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: media.width * 1,
          alignment: Alignment.topRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () async {
                    await context.setLocale(Locale('en', "US"));
                  },
                  child: Text("English")),
              TextButton(
                  onPressed: () async {
                    await context.setLocale(Locale('ur', 'PK'));
                  },
                  child: Text("Urdu"))
            ],
          ),
        ),
      ),
    );
  }
}
