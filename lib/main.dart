import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning/provider/digital_ink_provider.dart';
import 'package:learning/provider/game_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/auth_provider.dart';
import 'screens/auth/onboard.dart';
import 'screens/home.dart';
import 'screens/letter/letter_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProv()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(
            create: (context) => DigitalInkRecognitionState()),
      ],
      child: MaterialApp(
        title: 'Peekaboo Learn',
        theme: ThemeData(
            primarySwatch: myColor,
            // set font from google font
            textTheme: GoogleFonts.comicNeueTextTheme()),
        initialRoute: "/",
        routes: {
          '/': (context) => const IndexWid(),
          '/home': (context) => const HomeScreen(),
          '/onboard': (context) => const OnboardScreen(),
          "/letter": (context) => const LetterScreen(),
        },
      ),
    );
  }
}

class IndexWid extends StatelessWidget {
  const IndexWid({super.key});

  @override
  Widget build(BuildContext context) {
    Widget splashScreen = Scaffold(
      body: Center(
        child: Lottie.asset('assets/lottie/elephantjumb.json',
            fit: BoxFit.fitWidth),
      ),
    );
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // delay for 2 seconds to show splash screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Lottie.asset('assets/lottie/elephantjumb.json'),
            ),
          );
        } else if (snapshot.hasError) {
          return splashScreen;
        } else if (snapshot.hasData) {
          Provider.of<AuthProv>(context, listen: false).getProfile().then(
              (value) => Provider.of<GameProvider>(context, listen: false)
                  .gameInit()
                  .then(
                      (value) => Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pushReplacementNamed(context, '/home');
                          })));

          return splashScreen;
        }
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/onboard');
        });
        return splashScreen;
      },
    );
  }
}

const MaterialColor myColor = MaterialColor(
  0xFF0D6EFD,
  <int, Color>{
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  },
);
