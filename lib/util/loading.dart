import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: SizedBox(
      height: 250,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 200,
              child: Lottie.asset('assets/lottie/elephantjumb.json')),
          const SizedBox(
            height: 5,
          ),
          const Text("Please wait")
        ],
      ),
    ),
  );

  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: alert,
      );
    },
  );
}
