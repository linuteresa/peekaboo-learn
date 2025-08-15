import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieDialog extends StatelessWidget {
  final String animationPath;
  final String message;
  final Function() onOkPressed;

  const LottieDialog({
    Key? key,
    required this.animationPath,
    required this.message,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              animationPath,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: onOkPressed,
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

showSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => LottieDialog(
      animationPath: 'assets/lottie/sucess.json',
      message: 'Success!',
      onOkPressed: () {
        // Handle OK button pressed
        Navigator.of(context).pop(); // Close the dialog
      },
    ),
  );
}
